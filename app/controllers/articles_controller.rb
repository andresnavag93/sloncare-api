class ArticlesController < ApplicationController
  before_action :request_9!, only: [:create, :update, :destroy]
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /articles/
  def index
    super(Article, params[:locale])
  end

  # GET /articles/1
  def show
    super(@article, params[:locale])
  end

  # POST /articles
  def create
    @article = Checks::valid?(Article, article_params)
    base64 = ImageAws::extension?(params[:base64], 20, 21)
    errors = []
    errors = @article if @article.class == Array     
    errors << Errors::translate(base64) if base64.class == Integer
    if !errors.empty?
      return render json: {errors: errors}, status: :unprocessable_entity
    else
      @article.save
      picture = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, "news", "new-"+@article.id.to_s, nil, "defaults/image.png")
      @article.picture = picture
      @article.save
      return render json: {success: 1}, status: :ok
    end    
    #super(Article, article_params)
  end

  # PATCH/PUT /articles/1
  def update
    custom_params = article_params
    if params[:base64] != nil
      base64 = ImageAws::extension?(params[:base64], 20, 21)
      errors = []
      errors << Errors::translate(base64) if base64.class == Integer
      if !errors.empty?
        return render json: {errors: errors}, status: :unprocessable_entity
      else      
        aux = custom_params[:picture].split(Rails.configuration.url_s3 + "/").last
        picture = ImageAws::upload(params[:base64], Rails.configuration.route, Rails.configuration.bucket, "news", "new-"+@article.id.to_s, aux, "defaults/image.png")
        custom_params[:picture] = picture
      end
    end
    super(@article, custom_params)
  end

  # DELETE /articles/1
  def destroy
    super(@article)
  end

  def pagination
    super(Article, params[:init], params[:end])
  end

  def pagination_without
    @offset = params[:init].to_i
    @limit = params[:end].to_i - @offset + 1
    @objs = Article.order("created_at DESC").offset(@offset).limit(@limit).where.not("id = ?", params[:id])
    render json: @objs 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def article_params
      params.require(:article).permit(:title, :description, :picture, :locale_id)
    end
end
