require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"}
  end

  it "should create an user given valid attributes" do
    User.create! @attr
  end

  it "should require a name" do
    no_name_user = User.new( @attr.merge( :name => "" ) )
    no_name_user.should_not be_valid
  end

  it "should require an email" do
    no_email_user = User.new @attr.merge( :email => "" )
    no_email_user.should_not be_valid
  end

  it "should reject too long names" do
    name = "A" * 51
    long_name_user = User.new @attr.merge( :name => name )
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create! @attr
    user_with_duplicate_email = User.new @attr
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    User.create! @attr
    user_with_duplicate_email = User.new @attr.merge( :email => @attr[:email].upcase )
    user_with_duplicate_email.should_not be_valid
  end

  describe 'password validations' do
    it "should require a password" do
      user = User.new( @attr.merge :password => "", :password_confirmation => "" )
      user.should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new( @attr.merge :password_confirmation => "invalid" ).should_not be_valid
    end

    it "should reject short passwords" do
      pass = "a" * 5
      User.new( @attr.merge :password => pass, :password_confirmation => pass ).should_not be_valid
    end

    it "should reject long passwords" do
      pass = "a" * 41
      User.new( @attr.merge :password => pass, :password_confirmation => pass ).should_not be_valid
    end
  end
  describe 'password encryption' do
    before :each do
      @user = User.create! @attr
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to :encrypted_password
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should rbbe true if the passwords match" do
        @user.has_password?( @attr[:password] ).should be_true
      end

      it "should be false if the passwords don't match" do
        @user.has_password?( "invalid" ).should be_false
      end
    end

    describe "authenticate method" do
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate @attr[:email], "wrongpass"
        wrong_password_user.should be_nil
      end
      it "should return nil for an email address with no user" do
        no_user = User.authenticate "wrongemail@email.com", @attr[:password]
        no_user.should be_nil
      end
      it "should return the user on email/password match" do
        user = User.authenticate @attr[:email], @attr[:password]
        user.should == @user
      end
    end
  end
end
