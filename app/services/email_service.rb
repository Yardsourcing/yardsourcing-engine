class EmailService
  def self.send_email(to, from, subject, content)
    response = connection.post('/api/v1/mail') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params = {to: to, from: from, subject: subject, content: content}
    end

    return true if response.status == 202
    false
  end

  def self.connection
    Faraday.new(url: "https://peaceful-bastion-57477.herokuapp.com")
  end

  # "http://localhost:9292"
  # "https://peaceful-bastion-57477.herokuapp.com"
end
