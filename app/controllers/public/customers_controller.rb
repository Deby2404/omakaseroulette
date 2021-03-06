class Public::CustomersController < ApplicationController
   before_action :authenticate_customer!, except: [:top]

  def show
    @customer = current_customer
    @menus = @customer.menus.page(params[:page])
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    @customer.update(customer_params)
    redirect_to public_my_page_path
  end

  def withdrawal
    @customer = Customer.find(params[:id])
    @customer.update(is_deleted: true)
    reset_session
    flash[:notice] = '退会処理を実行いたしました'
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:name)
  end
end
