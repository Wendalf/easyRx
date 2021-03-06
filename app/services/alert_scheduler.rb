class AlertScheduler

  def self.check_and_send_alert
    
    alerts = Alert.all

    alerts.each do |alert|
      alert_time = alert.time.strftime("%H%M").to_i
      time_now = Time.now.strftime("%H%M").to_i
      edate = alert.prescription.experition_date.gsub("-", "").to_i
      if alert_time == time_now && edate > Time.now.to_datetime.strftime("%Y%m%d").to_i
        self.send_alert(alert)
      end
    end
  end

  def self.send_alert(alert)
    @twilio_number = ENV['TWILIO_FROM_NUMBER'] 
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    msg = "#{alert.patient.name}, please don't forget to take your #{alert.drug.name}."
    paitent_number = "+1" + "#{alert.patient.phone_number}"
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => paitent_number,
      :body => msg
    )
  end

  def self.send_initial_msg(patient)
    @twilio_number = ENV['TWILIO_FROM_NUMBER'] 
    @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    doctor = patient.user
    msg = "Dear #{patient.name}, this is a message from Dr. #{doctor.name}. You are now subscribed to your prescription alert. You will get text message alerts based on your new prescription. If you have any questions, please contact the doctor's offcie by phone at #{doctor.phone_number} or email at #{doctor.email}."
    patient_number = "+1" + "#{patient.phone_number}"
    message = @client.account.messages.create(
      :from => @twilio_number,
      :to => patient_number,
      :body => msg
    )
  end

end


