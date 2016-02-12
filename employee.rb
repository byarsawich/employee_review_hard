class Employee
  attr_reader :first_name, :middle_name, :last_name, :email, :phone_number
  attr_accessor :review, :performance

  def initialize(first_name, last_name, email, phone_number, salary, middle_name = "")
    @first_name = first_name
    @middle_name = middle_name
    @last_name = last_name
    @email = email
    @phone_number = phone_number
    @salary = salary.to_f
    @review = ""
    @performance = nil
  end

  def salary
    @salary.to_f
  end

  def name
    @middle_name != "" ? "#{@first_name} #{@middle_name} #{@last_name}" : "#{@first_name} #{@last_name}"
  end

  def give_raise!(amount)
     amount > 1.0 ? @salary += amount : @salary = @salary * (1 + amount)
  end

  def ==(e)
    @first_name == e.first_name
    @middle_name == e.middle_name
    @last_name == e.last_name
    @email == e.email
    @phone_number == e.phone_number
    @salary == salary
  end

  def import_employee_review(filename)
    input = File.open(filename, "r")
    temp_array = input.readlines("\n")
    input.close
    reg = /\b#{@first_name}\b/i
    temp_array.each  {|s| @review += s.gsub("\n", "") if s.match(reg)}
  end

  def assign_employee_performance
    #expected tokens in order of negative, negative qualifiers, positive, positive qualifiers
    temp_tokens = get_review_tokens
    negative_score = get_score(temp_tokens[0].split(","), temp_tokens[1].split(","))
    positive_score = get_score(temp_tokens[2].split(","), temp_tokens[3].split(","))
    positive_score - negative_score > 0 ? @performance = true : @performance = false
  end

  private def get_score(words, qualifiers)
    total = 0
    words.each do |w|
      if @review.match(/\b#{w}\b/i)
        qualifiers.each do |q|
          total += 2 if @review.match(/\b#{q}\b\s(\S+\s){,2}\b#{w}\b/i)
        end
        total += 1
      end
    end
    total
  end

  private def get_review_tokens
    input = File.open("tokens")
    temp_array = input.readlines("\n")
    temp_array.each {|s| s.strip!}
    input.close
    temp_array
  end
end
