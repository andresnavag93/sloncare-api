class StatisticsController < ApplicationController
  before_action :request_5!, only: [
    :count_sloncards, 
    :count_active_sloncards, 
    :money_fees,
    :money_gateways_payments
  ]

  before_action :request_7!, only: [
    :count_plans_beneficiaries, 
    :count_plans,
    :count_users,
    :count_services_types,
    :count_suggestions, 
  ]

  #STATISCS
    def count_plans_beneficiaries
        aux = [32, 31]
        a = []
        b_count = UserAccess.where("access_id = 69 AND EXTRACT(YEAR FROM created_at) = ? AND EXTRACT(MONTH FROM created_at) = ?", params[:year], params[:month]).count 
        a << {name: (I18n.t 'statisic.individual'), value: b_count}
        g_counts = GroupBeneficiary.joins(:group).select(:plan_id).where("EXTRACT(YEAR FROM group_beneficiaries.created_at) = ? AND EXTRACT(MONTH FROM group_beneficiaries.created_at) = ?", params[:year], params[:month]).group(:plan_id).count
        g_counts.each do |k,v|
            if k == 32
                a << {name: (I18n.t 'statisic.familiar'), value: v}
            else
                a << {name: (I18n.t 'statisic.corp'), value: v}
            end
            aux.delete(k)
        end
        aux.each do |k|
            if k == 32
                a << {name: (I18n.t 'statisic.familiar'), value: 0}
            else
                a << {name: (I18n.t 'statisic.corp'), value: 0}
            end
        end
        render json: a
    end

    def count_plans
        aux = [32, 31]
        a = []
        b_count = UserAccess.where("access_id = 69 AND EXTRACT(YEAR FROM created_at) = ? AND EXTRACT(MONTH FROM created_at) = ?", params[:year], params[:month]).count 
        a << {name: (I18n.t 'statisic.individual'), value: b_count}
        g_counts = Group.select(:plan_id).where("EXTRACT(YEAR FROM created_at) = ? AND EXTRACT(MONTH FROM created_at) = ?", params[:year], params[:month]).group(:plan_id).count
        g_counts.each do |k,v|
            if k == 32
                a << {name:(I18n.t 'statisic.familiar'), value: v}
            else
                a << {name:(I18n.t 'statisic.corp'), value: v}
            end
            aux.delete(k)
        end
        aux.each do |k|
            if k == 32
                a << {name:(I18n.t 'statisic.familiar'), value: 0}
            else
                a << {name:(I18n.t 'statisic.corp'), value: 0}
            end
        end
        render json: a
    end

    def count_users
       aux = [69,70,71,72,74]
        a = []
        users_count = UserAccess.select(:access_id).where("
          access_id not in (?) AND 
          EXTRACT(YEAR FROM created_at) = ? AND 
          EXTRACT(MONTH FROM created_at) = ?",
          [73,75,76,77,78], params[:year], params[:month]).group(:access_id).count
        users_count.each do |k,v|
          case k
            when 69
              a << {name:(I18n.t 'statisic.beneficiary'), value: v}
            when 70
              a << {name:(I18n.t 'statisic.doctor'), value: v}
            when 71
              a << {name:(I18n.t 'statisic.clinic'), value: v}
            when 72
              a << {name:(I18n.t 'statisic.group'), value: v}
            when 74
              a << {name:(I18n.t 'statisic.provider'), value: v}
          end
          aux.delete(k)
        end
        aux.each do |k|
          case k
            when 69
              a << {name:(I18n.t 'statisic.beneficiary'), value: 0}
            when 70
              a << {name:(I18n.t 'statisic.doctor'), value: 0}
            when 71
              a << {name:(I18n.t 'statisic.clinic'), value: 0}
            when 72
              a << {name:(I18n.t 'statisic.group'), value: 0}
            when 74
              a << {name:(I18n.t 'statisic.provider'), value: 0}
          end
        end
        render json: a
    end

    def count_sloncards
        aux = [10,20,25,30,50]
        a = []
        sloncard_count = Sloncode.select(:price).where("
          EXTRACT(YEAR FROM created_at) = ? AND 
          EXTRACT(MONTH FROM created_at) = ?",
          params[:year], params[:month]).group(:price).count
        sloncard_count.each do |k,v|
          case k
            when 10
              a << {name: k, value: v}
              aux.delete(k)
            when 20
              a << {name:k, value: v}
              aux.delete(k)
            when 25
              a << {name:k, value: v}
              aux.delete(k)
            when 30
              a << {name:k, value: v}
              aux.delete(k)
            when 50
              a << {name:k, value: v}
              aux.delete(k)
            else
              a << {name:k, value: v}
          end
        end
        aux.each do |k|
          case k
            when 10
              a << {name: k, value: 0}
            when 20
              a << {name:k, value: 0}
            when 25
              a << {name:k, value: 0}
            when 30
              a << {name:k, value: 0}
            when 50
              a << {name:k, value: 0}
          end
        end
        render json: a
    end

    def count_active_sloncards
        a = []
        sloncard_active = Sloncode.where("
          EXTRACT(YEAR FROM created_at) = ? AND 
          EXTRACT(MONTH FROM created_at) = ? AND transac_id is not ?",
          params[:year], params[:month], nil).count

        sloncard_not_active = Sloncode.where("
          EXTRACT(YEAR FROM created_at) = ? AND 
          EXTRACT(MONTH FROM created_at) = ? AND transac_id is ?",
          params[:year], params[:month], nil).count

          a << {value: sloncard_active, name: (I18n.t 'statisic.active')}
          a << {value: sloncard_not_active, name: (I18n.t 'statisic.no_active')}

        render json: a
    end

    def count_suggestions
        #aux = TblAttribute.where("tbl_attribute_id = 15").map { |x| x.id }
        aux = [128, 129, 130, 131, 132, 133, 134]
        #a = []
        a = {name: [], value: []}

        #Suggestion.where("suggestion_type_id = ?", params[:suggestion_type_id]).order("created_at DESC").offset(@offset).limit(@limit)

        suggestions = Suggestion.where("
          EXTRACT(YEAR FROM created_at) = ? AND 
          EXTRACT(MONTH FROM created_at) = ? AND
          suggestion_type_id in (?) ",params[:year], params[:month], aux).group(:suggestion_type_id).count
        suggestions.each do |k,v|
          case k
            when 128
              a[:value] << v 
              a[:name] << (I18n.t 'statisic.s1')
              #a << {name:(I18n.t 'statisic.s1'), value: v}
            when 129
              a[:value] << v 
              a[:name] << (I18n.t 'statisic.s2')
              #a << {name:(I18n.t 'statisic.s2'), value: v}
            when 130
              a[:value] << v 
              a[:name] << (I18n.t 'statisic.s3')
              #a << {name:(I18n.t 'statisic.s3'), value: v}
            when 131
              a[:value] << v 
              a[:name] << (I18n.t 'statisic.s4')
              #a << {name:(I18n.t 'statisic.s4'), value: v}
            when 132
              a[:value] << v 
              a[:name] << (I18n.t 'statisic.s5')
              #a << {name:(I18n.t 'statisic.s5'), value: v}
            when 133
              a[:value] << v 
              a[:name] << (I18n.t 'statisic.s6')
              #a << {name:(I18n.t 'statisic.s6'), value: v}
            when 134
              a[:value] << v 
              a[:name] << (I18n.t 'statisic.s7')
              #a << {name:(I18n.t 'statisic.s7'), value: v}
          end
          aux.delete(k)
        end
        aux.each do |k|
          case k
            when 128
              a[:value] << 0 
              a[:name] << (I18n.t 'statisic.s1')
              #a << {name:(I18n.t 'statisic.s1'), value: v}
            when 129
              a[:value] << 0 
              a[:name] << (I18n.t 'statisic.s2')
              #a << {name:(I18n.t 'statisic.s2'), value: v}
            when 130
              a[:value] << 0 
              a[:name] << (I18n.t 'statisic.s3')
              #a << {name:(I18n.t 'statisic.s3'), value: v}
            when 131
              a[:value] << 0 
              a[:name] << (I18n.t 'statisic.s4')
              #a << {name:(I18n.t 'statisic.s4'), value: v}
            when 132
              a[:value] << 0 
              a[:name] << (I18n.t 'statisic.s5')
              #a << {name:(I18n.t 'statisic.s5'), value: v}
            when 133
              a[:value] << 0 
              a[:name] << (I18n.t 'statisic.s6')
              #a << {name:(I18n.t 'statisic.s6'), value: v}
            when 134
              a[:value] << 0 
              a[:name] << (I18n.t 'statisic.s7')
              #a << {name:(I18n.t 'statisic.s7'), value: v}
          end
        end
        render json: a
    end

    def count_services_types
        aux = [84, 85, 86, 87, 88, 89]
        a = []
        fees = ServiceOrder.where("
          EXTRACT(YEAR FROM created_at) = ? AND 
          EXTRACT(MONTH FROM created_at) = ? AND
          service_type_id in (?) and status_id = 93",params[:year], params[:month], aux).group(:service_type_id).count #.sum(:total) Money
        fees.each do |k,v|
          case k
            when 84
              a << {name:(I18n.t 'statisic.os1'), value: v}
            when 85
              a << {name:(I18n.t 'statisic.os2'), value: v}
            when 86
              a << {name:(I18n.t 'statisic.os3'), value: v}
            when 87
              a << {name:(I18n.t 'statisic.os4'), value: v}
            when 88
              a << {name:(I18n.t 'statisic.os5'), value: v}
            when 89
              a << {name:(I18n.t 'statisic.os6'), value: v}
          end
          aux.delete(k)
        end
        aux.each do |k|
          case k
            when 84
              a << {name:(I18n.t 'statisic.os1'), value: 0}
            when 85
              a << {name:(I18n.t 'statisic.os2'), value: 0}
            when 86
              a << {name:(I18n.t 'statisic.os3'), value: 0}
            when 87
              a << {name:(I18n.t 'statisic.os4'), value: 0}
            when 88
              a << {name:(I18n.t 'statisic.os5'), value: 0}
            when 89
              a << {name:(I18n.t 'statisic.os6'), value: 0}
          end
        end
        render json: a
    end

    def money_fees
        aux = [123, 124, 125, 126, 127]
        a = []
        fees = Transac.where("
          EXTRACT(YEAR FROM created_at) = ? AND 
          EXTRACT(MONTH FROM created_at) = ? AND
          transac_type_id in (?) ",params[:year], params[:month], aux).group(:transac_type_id).sum(:amount)
        fees.each do |k,v|
          case k
            when 123
              a << {name:(I18n.t 'statisic.f1'), value: v}
            when 124
              a << {name:(I18n.t 'statisic.f2'), value: v}
            when 125
              a << {name:(I18n.t 'statisic.f3'), value: v}
            when 126
              a << {name:(I18n.t 'statisic.f4'), value: v}
            when 127
              a << {name:(I18n.t 'statisic.f5'), value: v}
          end
          aux.delete(k)
        end
        aux.each do |k|
          case k
            when 123
              a << {name:(I18n.t 'statisic.f1'), value: 0}
            when 124
              a << {name:(I18n.t 'statisic.f2'), value: 0}
            when 125
              a << {name:(I18n.t 'statisic.f3'), value: 0}
            when 126
              a << {name:(I18n.t 'statisic.f4'), value: 0}
            when 127
              a << {name:(I18n.t 'statisic.f5'), value: 0}
          end
        end
        render json: a
    end

    def money_gateways_payments
        aux = [34, 35]
        a = []
        sloncard_active = Sloncode.where("
          EXTRACT(YEAR FROM created_at) = ? AND 
          EXTRACT(MONTH FROM created_at) = ?",params[:year], params[:month]).group(:payment_id).sum(:price)
        sloncard_active.each do |k,v|
            if k == 34
                a << {name:(I18n.t 'statisic.p1'), value: v}
            else
                a << {name:(I18n.t 'statisic.p2'), value: v}
            end
            aux.delete(k)
        end
        aux.each do |k|
            if k == 34
                a << {name:(I18n.t 'statisic.p1'), value: 0}
            else
                a << {name:(I18n.t 'statisic.p2'), value: 0}
            end
        end
        render json: a
    end

end

