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
        User.valid_user.where(name: content).or(User.valid_user.where(our_answers_id: content))
      elsif method == 'partial'
        User.valid_user.where('name LIKE ?', '%' + content + '%')
        .or(User.valid_user.where('our_answers_id LIKE ?', '%' + content + '%'))
      elsif method == 'forward'
        User.valid_user.where('name LIKE ?',content + '%')
        .or(User.valid_user.where('our_answers_id LIKE ?', content + '%'))
      elsif method == 'backward'
        User.valid_user.where('name LIKE ?', '%' + content)
        .or(User.valid_user.where('our_answers_id LIKE ?', '%' + content))
      end
    elsif model == 'post'
      relations = [:user, :genre]
      if method == 'perfect'
        Post.includes(relations).showable.where(title: content)
        .or(Post.includes(relations).showable.where(body: content))
        .or(Post.includes(relations).showable.where(reference_url: content))
      elsif method == 'partial'
        Post.includes(relations).showable.where('title LIKE ?', '%' + content + '%')
        .or(Post.includes(relations).showable.where('body LIKE ?', '%' + content + '%'))
        .or(Post.includes(relations).showable.where('reference_url LIKE ?', '%' + content + '%'))
      elsif method == 'forward'
        Post.includes(relations).showable.where('title LIKE ?', content + '%')
        .or(Post.includes(relations).showable.where('body LIKE ?', content + '%'))
        .or(Post.includes(relations).showable.where('reference_url LIKE ?', content + '%'))
      elsif method == 'backward'
        Post.includes(relations).showable.where('title LIKE ?', '%' + content)
        .or(Post.includes(relations).showable.where('body LIKE ?', '%' + content))
        .or(Post.includes(relations).showable.where('reference_url LIKE ?', '%' + content))
      end
    end
  end

  def search_genre_for(value)
    Post.where(genre_id: value, release: true).includes(:user)
  end
end
