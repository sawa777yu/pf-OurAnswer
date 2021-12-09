class ContactsController < ApplicationController
  before_action :set_contact, only: [:confirm, :back, :create]

  def new
    @contact = Contact.new
  end

  def confirm
    render :new if @contact.invalid?
  end

  def back
    render :new
  end

  def create
    if @contact.save
      ContactMailer.send_mail(@contact).deliver_now
      redirect_to done_contacts_path
    else
      render :new
    end
  end

  def done; end

  private

  def contact_params
    params.require(:contact).permit(:email, :name, :message)
  end

  def set_contact
    @contact = Contact.new(contact_params)
  end
end
