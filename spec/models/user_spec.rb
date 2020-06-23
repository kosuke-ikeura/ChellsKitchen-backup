# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.create(
      name: 'Anakin',
      email: 'Anakin@Skaywalker',
      password: 'AnakinSkywalker'
    )
  end

  it 'is valid with a name, email, password' do
    expect(@user).to be_valid
  end

  it 'is invalid without name' do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'is invalid without e-mail' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without password' do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:user, email: 'tester@tester')
    user = FactoryBot.build(:user, email: 'tester@tester')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end
end
