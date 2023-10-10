module ApiMethods

  private
    def index(model, locale=28, serializer=nil)
      @objs = model.all
      if serializer.nil?
        render json: @objs, scope: {'locale': locale}
      else
        render json: @objs, each_serializer: serializer, scope: {'locale': locale}
      end
    end

    def show(obj, locale=28, serializer=nil)
      @obj = obj
      if @obj.respond_to? :locale_id
        locale = @obj.locale_id
      end
      if serializer.nil?
        render json: @obj, scope: {'locale': locale}
      else
        render json: @obj, serializer: serializer, scope: {'locale': locale}
      end
    end

    def create(model, obj_params)
      @obj = model.new(obj_params)
      if !@obj.valid?
        render json: {errors: Gets::errors(@obj.errors)}, status: :unprocessable_entity
      else
        @obj.save
        render json: {data: @obj, success: 1}, status: :created
      end
    end

    def update(obj, obj_params)
      @obj = obj
      if @obj.update(obj_params)
        render json: {data: @obj, success: 2}, status: :ok
      else
        render json: {errors: Gets::errors(@obj.errors)}, status: :unprocessable_entity
      end
    end

    def destroy(obj)
      @obj = obj
      @obj.destroy
      render json: {data: {}, success: 3}, status: :ok
    end

    def pagination(model, p_init, p_end)
      @offset = p_init.to_i
      @limit = p_end.to_i - @offset + 1
      @objs = model.order("created_at DESC").offset(@offset).limit(@limit)
      render json: @objs 
    end

    def nested_pagination(obj, function)
      @offset = params[:init].to_i
      @limit = params[:end].to_i - @offset + 1
      @objs = obj.public_send(function).order("created_at DESC").offset(@offset).limit(@limit)
      render json: @objs
    end

    def show_wallet(obj, locale=28, serializer=nil)
      @obj = obj
      if @obj.respond_to? :locale_id
        locale = @obj.locale_id
      end
      if serializer.nil?
        render json: @obj, scope: {'locale': locale}
      else
        render json: @obj, serializer: serializer, scope: {'locale': locale}
      end
    end
end