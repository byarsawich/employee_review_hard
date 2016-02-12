require 'minitest/autorun'
require 'minitest/pride'

#Note: This line is going to fail first.
require './department.rb'

class EmployeeReview < Minitest::Test
  def test_classes_exists
    assert Employee
    assert Department
  end

  def test_create_new_employee_and_get_attributes
    e = Employee.new("Brian", "Yarsawich", "test@test.com", "919-555-5555", 150000)
    assert e
    assert_equal "Brian", e.first_name
    assert_equal "Yarsawich", e.last_name
    assert_equal "Brian Yarsawich", e.name
    assert_equal 150000, e.salary
  end

  def test_add_employee_review
    e = Employee.new("Brian", "Yarsawich", "test@test.com", "919-555-5555", 150000)
    e.review = "Obviously the best employee this company has ever seen."
    assert_equal "Obviously the best employee this company has ever seen.", e.review
  end

  def test_add_employee_performance
    e = Employee.new("Brian", "Yarsawich", "test@test.com", "919-555-5555", 150000)
    e.performance = true
    assert e.performance
    f = Employee.new("John", "Doe", "scum@test.com", "919-111-1111", 10000)
    f.performance = false
    refute f.performance
  end

  def test_give_employee_raise
    e = Employee.new("Brian", "Yarsawich", "test@test.com", "919-555-5555", 150000)
    assert_equal 150000, e.salary
    e.give_raise!(20000)
    assert_equal 170000, e.salary
    f = Employee.new("John", "Doe", "scum@test.com", "919-111-1111", 10000)
    f.give_raise!(0.01)
    assert_equal 10100, f.salary
  end

  def test_create_new_department
    d = Department.new("Human Resources")
    assert d
    assert_equal "Human Resources", d.name
  end

  def test_add_employee_to_department
    d = Department.new("Development")
    e = Employee.new("Brian", "Yarsawich", "test@test.com", "919-555-5555", 150000)
    d.add_employee(e)
    assert_equal e, d.get_employee(name: "Brian Yarsawich")
    assert_equal e, d.get_employee(email: "test@test.com")
  end

  def test_get_all_employees_in_department
    d = Department.new("Development")
    e1 = Employee.new("Brian", "Yarsawich", "test@test.com", "919-555-5555", 150000)
    e2 = Employee.new("John", "Doe", "scum@test.com", "919-111-1111", 10000)
    d.add_employee(e1)
    d.add_employee(e2)
    assert_equal [e1,e2], d.get_employee_list
  end

  def test_get_total_salary_for_department
    d = Department.new("Development")
    d.add_employee(Employee.new("Brian", "Yarsawich", "test@test.com", "919-555-5555", 150000))
    d.add_employee(Employee.new("John", "Doe", "scum@test.com", "919-111-1111", 10000))
    assert_equal 160000, d.total_salary
  end

  def test_give_department_a_raise_all_same
    d = Department.new("Development")
    d.add_employee(Employee.new("Brian", "Yarsawich", "test@test.com", "919-555-5555", 150000))
    d.add_employee(Employee.new("John", "Doe", "scum@test.com", "919-111-1111", 10000))
    d.add_employee(Employee.new("Jane", "Doe", "jane@test.com", "919-555-1234", 100000))
    d.add_employee(Employee.new("Jack", "Doe", "jack@test.com", "919-123-1111", 80000))
    d.add_employee(Employee.new("Jack", "Black", "black@test.com", "919-123-5555", 120000))
    d.add_employee(Employee.new("John", "Smith", "smith@test.com", "919-111-5555", 50000))
    d.get_employee_list.each do |e|
      e.performance = true
    end
    d.give_raise!(60000) do |e|
      e.performance == true
    end
    assert_equal 570000, d.total_salary
    assert_equal 160000, d.get_employee(name: "Brian Yarsawich").salary
    assert_equal 20000, d.get_employee(name: "John Doe").salary
    assert_equal 110000, d.get_employee(name: "Jane Doe").salary
    assert_equal 90000, d.get_employee(name: "Jack Doe").salary
    assert_equal 130000, d.get_employee(name: "Jack Black").salary
    assert_equal 60000, d.get_employee(name: "John Smith").salary
  end

  def test_give_department_a_raise_equally_based_on_performance
    d = Department.new("Development")
    d.add_employee(Employee.new("Brian", "Yarsawich", "test@test.com", "919-555-5555", 150000))
    d.add_employee(Employee.new("John", "Doe", "scum@test.com", "919-111-1111", 10000))
    d.add_employee(Employee.new("Jane", "Doe", "jane@test.com", "919-555-1234", 100000))
    d.add_employee(Employee.new("Jack", "Doe", "jack@test.com", "919-123-1111", 80000))
    d.add_employee(Employee.new("Jack", "Black", "black@test.com", "919-123-5555", 120000))
    d.add_employee(Employee.new("John", "Smith", "smith@test.com", "919-111-5555", 50000))
    d.get_employee_list.each do |e|
      if e.last_name == "Doe"
        e.performance = false
      else
        e.performance = true
      end
    end
    d.give_raise!(60000) do |e|
      e.performance == true
    end
    assert_equal 570000, d.total_salary
    assert_equal 170000, d.get_employee(name: "Brian Yarsawich").salary
    assert_equal 10000, d.get_employee(name: "John Doe").salary
    assert_equal 100000, d.get_employee(name: "Jane Doe").salary
    assert_equal 80000, d.get_employee(name: "Jack Doe").salary
    assert_equal 140000, d.get_employee(name: "Jack Black").salary
    assert_equal 70000, d.get_employee(name: "John Smith").salary
  end

  def test_give_department_a_raise_based_on_current_pay
    d = Department.new("Development")
    d.add_employee(Employee.new("Brian", "Yarsawich", "test@test.com", "919-555-5555", 150000))
    d.add_employee(Employee.new("John", "Doe", "scum@test.com", "919-111-1111", 10000))
    d.add_employee(Employee.new("Jane", "Doe", "jane@test.com", "919-555-1234", 100000))
    d.add_employee(Employee.new("Jack", "Doe", "jack@test.com", "919-123-1111", 80000))
    d.add_employee(Employee.new("Jack", "Black", "black@test.com", "919-123-5555", 120000))
    d.add_employee(Employee.new("John", "Smith", "smith@test.com", "919-111-5555", 50000))
    d.get_employee_list.each do |e|
      if e.last_name == "Doe"
        e.performance = false
      else
        e.performance = true
      end
    end
    d.give_raise!(60000) do |e|
      e.salary < 100000
    end
    assert_equal 570000, d.total_salary
    assert_equal 150000, d.get_employee(name: "Brian Yarsawich").salary
    assert_equal 30000, d.get_employee(name: "John Doe").salary
    assert_equal 100000, d.get_employee(name: "Jane Doe").salary
    assert_equal 100000, d.get_employee(name: "Jack Doe").salary
    assert_equal 120000, d.get_employee(name: "Jack Black").salary
    assert_equal 70000, d.get_employee(name: "John Smith").salary
  end

  def test_review_file_exist
    assert File.exist?("sample_reviews.txt")
  end

  def test_file_can_be_opened_for_reading
    e = Employee.new("Zeke", "Smith", "smith@test.com", "919-111-5555", 50000)
    assert e.import_employee_review("sample_reviews.txt")
  end

  def test_employee_review_can_be_imported_from_file
    e = Employee.new("Zeke", "Smith", "smith@test.com", "919-111-5555", 50000)
    e.import_employee_review("sample_reviews.txt")
    assert_equal "Zeke is a very positive person and encourages those around him, but he has not done well technically this year.  There are two areas in which Zeke has room for improvement.  First, when communicating verbally (and sometimes in writing), he has a tendency to use more words than are required.  This conversational style does put people at ease, which is valuable, but it often makes the meaning difficult to isolate, and can cause confusion.Second, when discussing new requirements with project managers, less of the information is retained by Zeke long-term than is expected.  This has a few negative consequences: 1) time is spent developing features that are not useful and need to be re-run, 2) bugs are introduced in the code and not caught because the tests lack the same information, and 3) clients are told that certain features are complete when they are inadequate.  This communication limitation could be the fault of project management, but given that other developers appear to retain more information, this is worth discussing further.", e.review
    e = Employee.new("Wanda", "Doe", "Doe@test.com", "919-111-5555", 50000)
    e.import_employee_review("sample_reviews.txt")
    assert_equal "Wanda has been an incredibly consistent and effective developer.  Clients are always satisfied with her work, developers are impressed with her productivity, and she's more than willing to help others even when she has a substantial workload of her own.  She is a great asset to Awesome Company, and everyone enjoys working with her.  During the past year, she has largely been devoted to work with the Cement Company, and she is the perfect woman for the job.  We know that work on a single project can become monotonous, however, so over the next few months, we hope to spread some of the Cement Company work to others.  This will also allow Wanda to pair more with others and spread her effectiveness to other projects.", e.review
  end

  def test_review_is_assigned_based_on_imported_reveiew
    e = Employee.new("Zeke", "Smith", "smith@test.com", "919-111-5555", 50000)
    e.import_employee_review("sample_reviews.txt")
    e.assign_employee_performance
    assert_equal false, e.performance
    e = Employee.new("Wanda", "Doe", "Doe@test.com", "919-111-5555", 50000)
    e.import_employee_review("sample_reviews.txt")
    e.assign_employee_performance
    assert_equal true, e.performance
  end
end
