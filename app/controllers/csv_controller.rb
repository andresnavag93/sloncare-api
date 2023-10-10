class CsvController < ApplicationController
  before_action :request_5!, only: [:update_tabulators]

  def update_tabulators
    @codes_not_found = []
    @codes_update = []
    @email = params[:email]
    @url = params[:url]
    if !@email or !@url
      render json: {errors: [Errors::translate(81)]}, status: :unprocessable_entity
    elsif !['84','85','86'].include? params[:id]
      render json: {errors: [Errors::translate(60)]}, status: :unprocessable_entity
    else
      @service = TblAttribute.find(params[:id])
      begin
        if @url.include? ".csv" 
          @data = "csv"
          CSV.new(open(@url), encoding: "UTF-8").each do |line|
            update_price(@service, line[0], line[1])
          end
        elsif @url.include? ".xlsx" 
          @data = "xlsx"
          Roo::Spreadsheet.open(@url, encoding: "UTF-8").each do |line|
            update_price(@service, line[0].to_s, line[1].to_s)
          end
        end
        locale = Gets::locale(params[:locale])
        #Thread.new do
          ModelMailer.send_update_tabulators(
            @email, @service.name, @codes_update, @codes_not_found, locale).deliver
        #  ActiveRecord::Base.connection.close
        #   end
        render json: {success:1}, status: :ok
      rescue 
        render json: {errors: [Errors::translate(82)]}, status: :unprocessable_entity
      end
    end
  end

  def update_price(service, id, price)
    if !id.to_d == 0
      count = 0
      aux = Tabulator.find_by({service_type_id: service.id, id: id})
      if !aux.nil?
        @codes_not_found << code
      else
        aux.price = price.to_d
        aux.save
        @codes_update << code
      end
    end
  end
end
