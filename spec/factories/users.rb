# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name 'Obi-wan'
    sequence(:email) { |n| "MayTheForce#{n}@BeWithYou.com" }
    password 'tofacethetrials'
  end
end
