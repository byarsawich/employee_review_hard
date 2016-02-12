require './employee'

class Department
  attr_reader :name

  def initialize(name)
    @name = name
    @employees = []
  end

  def add_employee(employee)
    @employees << employee
  end

  def get_employee(name: nil, email: nil)
    if name.nil?
      get_employee_by_email(email).first
    else
      get_employee_by_name(name).first
    end
  end

  private def get_employee_by_name(name)
    @employees.select {|e| e.name == name}
  end

  private def get_employee_by_email(email)
    @employees.select {|e| e.email == email}
  end

  def total_salary
    @employees.reduce(0.0) {|sum, e| sum + e.salary}
  end

  def get_employee_list
    @employees
  end

  def give_raise!(amount)
    up_for_raise = @employees.select {|e| yield(e)}
    raise_amount = amount.to_f / up_for_raise.length
    up_for_raise.each {|e| e.give_raise!(raise_amount)}
  end

end
