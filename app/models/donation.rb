require 'fixer_io'

class Donation < ActiveRecord::Base

    belongs_to :project
    belongs_to :donor, :class_name => 'Organization'

    validates_presence_of :donor_id, :project_id
    validates_presence_of :date, :amount_currency, :if => lambda { amount_present? }

    before_validation :nullify_amount
    before_validation :set_amount_date
    before_save :set_amount_usd
        
    def amount_present?
        amount.present?
    end
    
    def amount=(value)
        if value.present? && value != 0
            write_attribute(:amount, value.tr(",",""))
        end
    end

    def change_label
        [donor.name, date.try(:strftime, '%m/%d/%Y'), "$#{amount.to_f}"].map(&:presence).compact.join(' -  ')
    end
  
    def nullify_amount
        if amount == 0 || amount == ''
        amount = nil
        end
    end
    
    def set_amount_date
        date = Date.today if date.blank? && amount.present?
    end

    def set_amount_usd
        if amount_changed? || amount_currency_changed? || date_changed?
        if amount_currency == "USD"
            self.amount_usd = amount
        else
            self.amount_usd = amount_converted_to_usd
        end
        end
    end
    
    def amount_converted_to_usd
        conversion = FixerIo.new(date, amount_currency, "USD").rate
        if conversion.present?
            amount.to_d * conversion.to_d
        end
    rescue
        nil
    end

end
