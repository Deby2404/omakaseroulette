class Admin::ContactsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @customers = Customer.all
    @contacts = Contact.page(params[:page]).order(created_at: :desc).per(10)
    Notification.confirmed
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    @contact.update(contact_params)
    @customer = @contact.customer
    ChatMailer.send_when_admin_reply(@customer,@contact).deliver_now
    redirect_to admin_customers_path
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    @contacts = Contact.page(params[:page]).order(created_at: :desc).per(10)
    @customers = Customer.all
    render :index
  end

  private

  def contact_params
    params.require(:contact).permit(:title,:body,:reply)
  end
end
