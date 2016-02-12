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
    total = 0
    temp_tokens[0].each do |w|
      if @review.match(/\b#{w}\b/i)
        total -= 1
        total -= get_negative_score(temp_tokens[1], w)
      end
    end
    temp_tokens[2].each do |w|
      if @review.match(/\b#{w}\b/i)
        total += 1
        total += get_positive_score(temp_tokens[1],temp_tokens[3],w)
      end
    end
    puts "#{@first_name} #{total}"
    total > 0 ? @performance = true : @performance = false
  end

  private def get_negative_score(qualifiers, word)
    total = 0
    qualifiers.each do |q|
      total += 2 if @review.match(/\b#{q}\b\s(\S+\s){,2}\b#{word}\b/i)
    end
    total
  end

  private def get_positive_score(negative_qualifiers, positive_qualifiers, word)
    total = 0
    positive_qualifiers.each do |pq|
      if @review.match(/\b#{pq}\b\s(\S+\s){,2}\b#{word}\b/i)
        negative = false
        negative_qualifiers.each do |nq|
          negative = true if @review.match(/\b#{nq}\b\s(\S+\s)\b#{pq}\b/i)
        end
        negative ? total -= 3 : total += 2
      end
    end
    total
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
    results = []
    temp_array = input.readlines("\n")
    temp_array.each do |s|
      s.strip!
      results << s.split(",")
    end
    input.close
    results
  end
end
