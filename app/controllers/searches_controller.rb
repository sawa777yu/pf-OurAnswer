class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    @records = search_for(@model, @content, @method)
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
      end
    elsif model == 'post'
      if method == 'perfect'
        Post.where(title: content, release: true).includes(:genre,
                                                           :user).or(Post.where(body: content, release: true).includes(:genre,
                                                                                                                       :user).or(Post.where(reference_url: content, release: true).includes(
                                                                                                                                   :genre, :user
                                                                                                                                 )))
      elsif method == 'partial'
        Post.where(release: true).where('title LIKE ?',
                                        '%' + content + '%').includes(:genre, :user).or(Post.where('body LIKE ?',
                                                                                                   '%' + content + '%').includes(:genre, :user).or(Post.where('reference_url LIKE ?',
                                                                                                                                                              '%' + content + '%').includes(:genre, :user)))
      elsif method == 'forward'
        Post.where(release: true).where('title LIKE ?',
                                        content + '%').includes(:genre, :user).or(Post.where('body LIKE ?',
                                                                                             content + '%').includes(:genre, :user).or(Post.where('reference_url LIKE ?', content + '%').includes(
                                                                                                                                         :genre, :user
                                                                                                                                       )))
      elsif method == 'backward'
        Post.where(release: true).where('title LIKE ?',
                                        '%' + content).includes(:genre, :user).or(Post.where('body LIKE ?',
                                                                                             '%' + content).includes(:genre, :user).or(Post.where('reference_url LIKE ?', '%' + content).includes(
                                                                                                                                         :genre, :user
                                                                                                                                       )))
      end
    end
  end

  def search_genre_for(value)
    Post.where(genre_id: value, release: true).includes(:user)
  end
end
