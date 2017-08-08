class IatiMailer < ActionMailer::Base
   default :from => 'no-reply@ngoaidmap.org'
   
   def sync(to, result, preview=false)
       @result = result
       subject = "IATI Registry Sync Report"
       subject += " [PREVIEW]" if preview.eql?(true)
       mail(:to => to, :subject => subject)
   end
   
   if Rails.env.development?
      class Preview < MailView
         def sync
            to = Rails.configuration.iati_publisher_email
            result = {
                :add => {:total => 3, :errors => [] },
                :remove => {:total => 0, :errors => [] },
                :update => {:total => 35, :errors => [HTTParty.get('https://iati-staging.ckan.io/api/action/package_search?rows=3&qs_param_does_not_exist=organization')] }
            }
            ::IatiMailer.sync(to, result, true)
         end
      end
   end
end