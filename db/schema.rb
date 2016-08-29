# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160829182015) do

  create_table "comics", force: :cascade do |t|
    t.string  "title"
    t.integer "issue",      precision: 38
    t.string  "publisher"
    t.date    "created_at"
    t.date    "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "user_name"
    t.text     "body"
    t.integer  "idea_id",    precision: 38
    t.datetime "created_at", precision: 6,  null: false
    t.datetime "updated_at", precision: 6,  null: false
  end

  create_table "countries", comment: "country table. Contains 25 rows. References with locations table.", primary_key: "country_id", id: :string, limit: 2, comment: "Primary key of countries table.", force: :cascade do |t|
    t.string  "country_name", limit: 40, comment: "Country name"
    t.decimal "region_id",               comment: "Region ID for the country. Foreign key to region_id column in the departments table."
  end

  create_table "departments", comment: "Departments table that shows details of departments where employees\nwork. Contains 27 rows; references with locations, employees, and job_history tables.", primary_key: "department_id", force: :cascade do |t|
    t.string  "department_name", limit: 30,               null: false, comment: "A not null column that shows name of a department. Administration,\nMarketing, Purchasing, Human Resources, Shipping, IT, Executive, Public\nRelations, Sales, Finance, and Accounting. "
    t.integer "manager_id",      limit: 6,  precision: 6,              comment: "Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column."
    t.integer "location_id",     limit: 4,  precision: 4,              comment: "Location id where a department is located. Foreign key to location_id column of locations table."
  end

  add_index "departments", ["location_id"], name: "dept_location_ix"

  create_table "employees", comment: "employees table. Contains 107 rows. References with departments,\njobs, job_history tables. Contains a self reference.", primary_key: "employee_id", force: :cascade do |t|
    t.string  "first_name",     limit: 20,                                      comment: "First name of the employee. A not null column."
    t.string  "last_name",      limit: 25,                         null: false, comment: "Last name of the employee. A not null column."
    t.string  "email",          limit: 25,                         null: false, comment: "Email id of the employee"
    t.string  "phone_number",   limit: 20,                                      comment: "Phone number of the employee; includes country code and area code"
    t.date    "hire_date",                                         null: false, comment: "Date when the employee started on this job. A not null column."
    t.string  "job_id",         limit: 10,                         null: false, comment: "Current job of the employee; foreign key to job_id column of the\njobs table. A not null column."
    t.decimal "salary",                    precision: 8, scale: 2,              comment: "Monthly salary of the employee. Must be greater\nthan zero (enforced by constraint emp_salary_min)"
    t.decimal "commission_pct",            precision: 2, scale: 2,              comment: "Commission percentage of the employee; Only employees in sales\ndepartment elgible for commission percentage"
    t.integer "manager_id",     limit: 6,  precision: 6,                        comment: "Manager id of the employee; has same domain as manager_id in\ndepartments table. Foreign key to employee_id column of employees table.\n(useful for reflexive joins and CONNECT BY query)"
    t.integer "department_id",  limit: 4,  precision: 4,                        comment: "Department id where employee works; foreign key to department_id\ncolumn of the departments table"
  end

  add_index "employees", ["department_id"], name: "emp_department_ix"
  add_index "employees", ["email"], name: "emp_email_uk", unique: true
  add_index "employees", ["job_id"], name: "emp_job_ix"
  add_index "employees", ["last_name", "first_name"], name: "emp_name_ix"
  add_index "employees", ["manager_id"], name: "emp_manager_ix"

  create_table "foods", force: :cascade do |t|
    t.string  "name"
    t.boolean "purchased"
    t.date    "created_at"
    t.date    "updated_at"
  end

  create_table "ideas", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "picture"
    t.datetime "created_at",  precision: 6, null: false
    t.datetime "updated_at",  precision: 6, null: false
  end

  create_table "job_history", comment: "Table that stores job history of the employees. If an employee\nchanges departments within the job or changes jobs within the department,\nnew rows get inserted into this table with old job information of the\nemployee. Contains a complex primary key: employee_id+start_date.\nContains 25 rows. References with jobs, employees, and departments tables.", primary_key: ["employee_id", "start_date"], force: :cascade do |t|
    t.integer "employee_id",   limit: 6,  precision: 6, null: false, comment: "A not null column in the complex primary key employee_id+start_date.\nForeign key to employee_id column of the employee table"
    t.date    "start_date",                             null: false, comment: "A not null column in the complex primary key employee_id+start_date.\nMust be less than the end_date of the job_history table. (enforced by\nconstraint jhist_date_interval)"
    t.date    "end_date",                               null: false, comment: "Last day of the employee in this job role. A not null column. Must be\ngreater than the start_date of the job_history table.\n(enforced by constraint jhist_date_interval)"
    t.string  "job_id",        limit: 10,               null: false, comment: "Job role in which the employee worked in the past; foreign key to\njob_id column in the jobs table. A not null column."
    t.integer "department_id", limit: 4,  precision: 4,              comment: "Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table"
  end

  add_index "job_history", ["department_id"], name: "jhist_department_ix"
  add_index "job_history", ["employee_id"], name: "jhist_employee_ix"
  add_index "job_history", ["job_id"], name: "jhist_job_ix"

  create_table "jobs", comment: "jobs table with job titles and salary ranges. Contains 19 rows.\nReferences with employees and job_history table.", primary_key: "job_id", id: :string, limit: 10, comment: "Primary key of jobs table.", force: :cascade do |t|
    t.string  "job_title",  limit: 35,               null: false, comment: "A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT"
    t.integer "min_salary", limit: 6,  precision: 6,              comment: "Minimum salary for a job title."
    t.integer "max_salary", limit: 6,  precision: 6,              comment: "Maximum salary for a job title"
  end

  create_table "locations", comment: "Locations table that contains specific address of a specific office,\nwarehouse, and/or production site of a company. Does not store addresses /\nlocations of customers. Contains 23 rows; references with the\ndepartments and countries tables. ", primary_key: "location_id", force: :cascade do |t|
    t.string "street_address", limit: 40,              comment: "Street address of an office, warehouse, or production site of a company.\nContains building number and street name"
    t.string "postal_code",    limit: 12,              comment: "Postal code of the location of an office, warehouse, or production site\nof a company. "
    t.string "city",           limit: 30, null: false, comment: "A not null column that shows city where an office, warehouse, or\nproduction site of a company is located. "
    t.string "state_province", limit: 25,              comment: "State or Province where an office, warehouse, or production site of a\ncompany is located."
    t.string "country_id",     limit: 2,               comment: "Country where an office, warehouse, or production site of a company is\nlocated. Foreign key to country_id column of the countries table."
  end

  add_index "locations", ["city"], name: "loc_city_ix"
  add_index "locations", ["country_id"], name: "loc_country_ix"
  add_index "locations", ["state_province"], name: "loc_state_province_ix"

  create_table "microposts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id",    precision: 38
    t.datetime "created_at", precision: 6,  null: false
    t.datetime "updated_at", precision: 6,  null: false
  end

  create_table "nielsen_schedules", force: :cascade do |t|
    t.integer "week",       limit: 2, precision: 2, null: false
    t.date    "start_date",                         null: false
    t.date    "end_date",                           null: false
  end

  create_table "regions", primary_key: "region_id", id: :decimal, force: :cascade do |t|
    t.string "region_name", limit: 25
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "countries", "regions", primary_key: "region_id", name: "countr_reg_fk"
  add_foreign_key "departments", "employees", column: "manager_id", primary_key: "employee_id", name: "dept_mgr_fk"
  add_foreign_key "departments", "locations", primary_key: "location_id", name: "dept_loc_fk"
  add_foreign_key "employees", "departments", primary_key: "department_id", name: "emp_dept_fk"
  add_foreign_key "employees", "employees", column: "manager_id", primary_key: "employee_id", name: "emp_manager_fk"
  add_foreign_key "employees", "jobs", primary_key: "job_id", name: "emp_job_fk"
  add_foreign_key "job_history", "departments", primary_key: "department_id", name: "jhist_dept_fk"
  add_foreign_key "job_history", "employees", primary_key: "employee_id", name: "jhist_emp_fk"
  add_foreign_key "job_history", "jobs", primary_key: "job_id", name: "jhist_job_fk"
  add_foreign_key "locations", "countries", primary_key: "country_id", name: "loc_c_id_fk"
end
