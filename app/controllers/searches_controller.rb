class SearchesController < ApplicationController

  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    @records = search_for(@model, @content, @method)
    # .includes(:user, :genre)でN+1問題解消
  end

  def search_genre
    @value = params['search']['value']
    @genre_records = search_genre_for(@value)
    @genre = Genre.find(@value)
  end

  private

  def search_for(model, content, method)
    if model == 'user'
      if method == 'perfect'
        User.where(name: content).or(User.where(our_answers_id: content))
      elsif method == 'partial'
        User.where('name LIKE ?', '%' + content + '%').or(User.where('our_answers_id LIKE ?', '%' + content + '%'))
      elsif method == 'forward'
        User.where('name LIKE ?', content + '%').or(User.where('our_answers_id LIKE ?', content + '%'))
      elsif method == 'backward'
        User.where('name LIKE ?', '%' + content).or(User.where('our_answers_id LIKE ?', '%' + content))
      else
        User.all
      end
    elsif model == 'post'
      if method == 'perfect'
        Post.where(title: content, release: true).or(Post.where(body: content, release: true).or(Post.where(reference_url: content, release: true)))
      elsif method == 'partial'
        Post.where('title LIKE ? and release=true',
                   '%' + content + '%').or(Post.where('body LIKE ? and release=true',
                                                      '%' + content + '%').or(Post.where('reference_url LIKE ? and release=true',
                                                                                         '%' + content + '%')))
      elsif method == 'forward'
        Post.where('title LIKE ? and release=true',
                   content + '%').or(Post.where('body LIKE ? and release=true',
                                                content + '%').or(Post.where('reference_url LIKE ? and release=true', content + '%')))
      elsif method == 'backward'
        Post.where('title LIKE ? and release=true',
                   '%' + content).or(Post.where('body LIKE ? and release=true',
                                                '%' + content).or(Post.where('reference_url LIKE ? and release=true', '%' + content)))
      else
        Post.all
      end
    end
  end

  def search_genre_for(value)
    Post.where(genre_id: value).includes(:user)
  end

end
