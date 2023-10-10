module ImageAws
  
  class << self

    def split(image, code)
      begin
        body = image.split(',')
        type_aws = body[0].split(';')[0].split(':')[1]
        extension = type_aws.split('/')[1]
        return extension
      rescue
        return code
      end
    end

    def extension?(image, *code)
      base64 = self.split(image, code[0])
      if base64.class == Integer
        return code[0]
      else
        if ![:jpeg, :jpg, :png].include? base64.to_sym 
          return code[1]
        else 
          return true
        end
      end
    end

    def upload(image, route, bucket, directory, filename, o_image=nil, d_image)
      begin
        body = image.split(',')
        type_aws = body[0].split(';')[0].split(':')[1]
        extension = type_aws.split('/')[1]
        body_aws = Base64.decode64(body[1])

        s3 = Aws::S3::Resource.new
        image_name = directory + "/" + filename + "." + extension

        if !o_image.nil? and o_image != d_image and o_image != image_name
          obj = s3.bucket(bucket).object(o_image)
          obj.delete
        end
        obj = s3.bucket(bucket).object(image_name)
        obj.put(body: body_aws, content_type: type_aws, content_encoding: 'base64')
        return route + bucket + "/" + obj.key
      rescue
        return route + bucket + "/" + d_image
      end
    end

  end
end


    # def upload(base64, route, bucket, directory, filename, image, o_image=nil, d_image=nil, *code)
    #   #begin 
    #     body_aws = Base64.decode64(base64[0])
    #     #if body_aws.bytesize <= 2000000
    #       s3 = Aws::S3::Resource.new
    #       if !o_image.nil? and !d_image.nil? and o_image != d_image
    #         obj = s3.bucket(bucket).object(o_image)
    #         obj.delete
    #       end
    #       obj = s3.bucket(bucket).object(directory + "/" + filename + "." + base64[2])
    #       obj.put(body: base64[0], content_type: base64[1], content_encoding: 'base64')
    #       return route + bucket + "/" + obj.key
    #     #else
    #     #  return code[1]
    #     #end      
    #   #rescue
    #   #  return code[0]
    #   #end
    # end