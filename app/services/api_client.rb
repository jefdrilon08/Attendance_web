class ApiClient
  BASE_URL = ENV.fetch("API_BASE_URL", "http://localhost:3001")

  def self.connection(token: nil)
    Faraday.new(url: BASE_URL) do |f|
      f.request :json
      f.response :json, content_type: /\bjson$/
      f.headers["Authorization"] = "Bearer #{token}" if token
      f.adapter Faraday.default_adapter
    end
  end

  def self.login(email, password)
    connection.post("/login") { |req| req.body = { user: { email: email, password: password } } }
  end

  def self.me(token)
    connection(token: token).get("/me")
  end

  def self.create_user(token, user_params)
    connection(token: token).post("/admin/users") { |req| req.body = { user: user_params } }
  end

  def self.branches(token)
    connection(token: token).get("/admin/branches")
  end

  def self.positions(token)
    connection(token: token).get("/admin/positions")
  end
  def self.user(token, id)
    connection(token: token).get("/admin/users/#{id}")
  end

  def self.toggle_branch(token, user_id, branch_id)
    connection(token: token).patch("/admin/users/#{user_id}/toggle_branch") { |req| req.body = { branch_id: branch_id } }
  end
  def self.users(token)
    connection(token: token).get("/admin/users")
  end
  
  def self.create_branch(token, branch_params)
    connection(token: token).post("/admin/branches") { |req| req.body = { branch: branch_params } }
  end

  def self.users(token)
    connection(token: token).get("/admin/users")
  end

  def self.clusters(token)
    connection(token: token).get("/admin/clusters")
  end

  def self.create_cluster(token, cluster_params)
    connection(token: token).post("/admin/clusters") { |req| req.body = { cluster: cluster_params } }
  end

  def self.areas(token)
    connection(token: token).get("/admin/areas")
  end

  def self.organization_structures(token)
    connection(token: token).get("/admin/organization_structures")
  end

  def self.cluster(token, id)
    connection(token: token).get("/admin/clusters/#{id}")
  end

  def self.create_area(token, area_params)
    connection(token: token).post("/admin/areas") { |req| req.body = { area: area_params } }
  end

  def self.create_organization_structure(token, org_params)
    connection(token: token).post("/admin/organization_structures") { |req| req.body = { organization_structure: org_params } }
  end

  def self.branch(token, id)
    connection(token: token).get("/admin/branches/#{id}")
  end

  def self.update_branch(token, id, branch_params)
    connection(token: token).patch("/admin/branches/#{id}") { |req| req.body = { branch: branch_params } }
  end

  def self.update_cluster(token, id, cluster_params)
    connection(token: token).patch("/admin/clusters/#{id}") { |req| req.body = { cluster: cluster_params } }
  end

  def self.area(token, id)
    connection(token: token).get("/admin/areas/#{id}")
  end

  def self.update_area(token, id, area_params)
    connection(token: token).patch("/admin/areas/#{id}") { |req| req.body = { area: area_params } }
  end

  def self.organization_structure(token, id)
    connection(token: token).get("/admin/organization_structures/#{id}")
  end

  def self.update_organization_structure(token, id, org_params)
    connection(token: token).patch("/admin/organization_structures/#{id}") { |req| req.body = { organization_structure: org_params } }
  end
  
  def self.update_user(token, id, user_params)
    connection(token: token).patch("/admin/users/#{id}") { |req| req.body = { user: user_params } }
  end
  def self.position(token, id)
    connection(token: token).get("/admin/positions/#{id}")
  end

  def self.create_position(token, position_params)
    connection(token: token).post("/admin/positions") { |req| req.body = { position: position_params } }
  end

  def self.update_position(token, id, position_params)
    connection(token: token).patch("/admin/positions/#{id}") { |req| req.body = { position: position_params } }
  end

#===================================Attendace
def self.my_dtr_submissions(token)
  connection(token: token).get("/dtr_submissions")
end

def self.dtr_submission(token, id)
  connection(token: token).get("/dtr_submissions/#{id}")
end

def self.pending_dtrs(token)
  connection(token: token).get("/dtr_submissions/pending")
end

def self.approve_dtr_group(token, period_start, period_end)
  connection(token: token).patch("/dtr_submissions/approve_group") do |req|
    req.body = { period_start: period_start, period_end: period_end }
  end
end

def self.return_dtr(token, id, reason)
  connection(token: token).patch("/dtr_submissions/#{id}/return") do |req|
    req.body = { return_reason: reason }
  end
end

def self.approved_dtrs(token)
  connection(token: token).get("/dtr_submissions/approved")
end

def self.admin_leave_types(token)
  connection(token: token).get("/admin/leave_types")
end

def self.admin_leave_type(token, id)
  connection(token: token).get("/admin/leave_types/#{id}")
end

def self.create_leave_type(token, leave_type_params)
  connection(token: token).post("/admin/leave_types") do |req|
    req.body = { leave_type: leave_type_params }
  end
end

def self.update_leave_balance(token, id, balance_params)
  connection(token: token).patch("/admin/employee_leave_balances/#{id}") do |req|
    req.body = { employee_leave_balance: balance_params }
  end
end

def self.update_leave_type(token, id, leave_type_params)
  connection(token: token).patch("/admin/leave_types/#{id}") { |req| req.body = { leave_type: leave_type_params } }
end

def self.leave_balances(token, user_id)
  connection(token: token).get("/admin/users/#{user_id}/employee_leave_balances")
end

def self.create_leave_balance(token, user_id, balance_params)
  connection(token: token).post("/admin/users/#{user_id}/employee_leave_balances") do |req|
    req.body = { employee_leave_balance: balance_params }
  end
end

def self.update_leave_balance(token, id, balance_params)
  connection(token: token).patch("/admin/employee_leave_balances/#{id}") do |req|
    req.body = { employee_leave_balance: balance_params }
  end
end

end
