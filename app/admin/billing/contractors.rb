ActiveAdmin.register Contractor do
  menu parent: "Billing",  priority: 2


  acts_as_audit
  acts_as_clone
  acts_as_safe_destroy
  acts_as_status
  acts_as_async_destroy('Contractor')
  acts_as_async_update('Contractor',
                       lambda do
                         {
                           enabled: boolean_select,
                           vendor: boolean_select,
                           customer: boolean_select,
                           description: 'text',
                           address: 'text',
                           phones: 'text',
                           smtp_connection_id: System::SmtpConnection.pluck(:name, :id)
                         }
                       end)

  acts_as_delayed_job_lock
  
  acts_as_export :id, :enabled, :name, :vendor,:customer
  acts_as_import resource_class: Importing::Contractor

  scope :vendors
  scope :customers

  permit_params :name, :enabled, :vendor, :customer ,:description, :address, :phones, :tech_contact, :fin_contact, :smtp_connection_id

  includes :smtp_connection

   #todo: check this endpoint is need
   collection_action :is_vendor do
     @contractors = Contractor.where(vendor: params[:vendor_flag])
     render text:                 view_context.options_from_collection_for_select(@contractors, :id, :display_name)
   end
   
   collection_action :get_accounts do
     contractor =  Contractor.find(params[:contractor_id])
     @accounts = contractor.accounts
     render text:                 view_context.options_from_collection_for_select(@accounts, :id, :display_name)
   end

  index do
    selectable_column
    id_column
    actions
    column :enabled
    column :name
    column :vendor
    column :customer
    column :external_id
    column :description
    column :address
    column :phones
    column :smtp_connection
  end

  show do |s|
    tabs do
      tab "Details" do
        attributes_table do
          row :id
          row :name
          row :external_id
          row :enabled
          row :vendor
          row :customer
          row :description
          row :address
          row :phones
          row :smtp_connection
        end
      end
      tab "Contacts" do
        panel "" do
          table_for s.contacts do
            column :id
            column :email
            column :notes
            column :created_at
            column :updated_at
          end
        end
      end
      tab "Comments" do
          active_admin_comments
      end
    end
  end


  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs form_title do
      f.input :name
      f.input :enabled
      f.input :vendor
      f.input :customer
      f.input :description
      f.input :address
      f.input :phones
      f.input :smtp_connection
    end
    f.actions
  end


  filter :id
  filter :name
  filter :enabled,as: :select, collection: [["Yes", true], ["No", false]]
  filter :vendor,as: :select, collection: [["Yes", true], ["No", false]]
  filter :customer,as: :select, collection: [["Yes", true], ["No", false]]
  filter :external_id

  sidebar :links, only: [:show, :edit] do

    ul do
      li do
        link_to "Gateways" , gateways_path(q: {contractor_id_eq: params[:id]})

      end
      li do
         link_to "Accounts" , accounts_path(q: {contractor_id_eq: params[:id]})
      end


    end
  end


end
