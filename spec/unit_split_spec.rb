require 'spec_helper'
require 'pp'

describe UnitSplit do

  it 'has a version number' do
    expect(UnitSplit::VERSION).not_to be nil
  end

  describe 'split' do

    describe 'simple case' do

      it 'can parse japanese number' do
        response = UnitSplit.split('87432912805000',
          UnitSplit::Unit::JapaneseNumber)
        expect(response.length).to eq 4
        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 5000
        expect(response[1][0]).to eq "man"
        expect(response[1][1]).to eq 1280
        expect(response[2][0]).to eq "oku"
        expect(response[2][1]).to eq 4329
        expect(response[3][0]).to eq "cho"
        expect(response[3][1]).to eq 87
      end

      it 'can parse bytes' do
        response = UnitSplit.split('32227983360',
          UnitSplit::Unit::Byte)
        expect(response.length).to eq 4

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 0

        expect(response[1][0]).to eq "KB"
        expect(response[1][1]).to eq 0

        expect(response[2][0]).to eq "MB"
        expect(response[2][1]).to eq 15

        expect(response[3][0]).to eq "GB"
        expect(response[3][1]).to eq 30
      end

    end

    describe 'border case (byte)' do
      KB = 2 ** 10
      MB = 2 ** 20
      GB = 2 ** 30
      
      it '0, 1023 sec' do
        response = UnitSplit.split('0',
          UnitSplit::Unit::Byte)
        expect(response.length).to eq 1
        expect(response[0][1]).to eq 0

        response = UnitSplit.split((KB - 1).to_s,
          UnitSplit::Unit::Byte)
        expect(response.length).to eq 1
        expect(response[0][1]).to eq (KB - 1)
      end

      it 'KB' do
        response = UnitSplit.split(KB.to_s,
          UnitSplit::Unit::Byte)
        expect(response.length).to eq 2

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 0

        expect(response[1][0]).to eq 'KB'
        expect(response[1][1]).to eq 1
      end

      it 'KB + 1 byte' do
        response = UnitSplit.split((KB + 1).to_s,
          UnitSplit::Unit::Byte)
        expect(response.length).to eq 2

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 1

        expect(response[1][0]).to eq 'KB'
        expect(response[1][1]).to eq 1
      end

      it 'MB' do
        response = UnitSplit.split(MB.to_s,
          UnitSplit::Unit::Byte)
        expect(response.length).to eq 3

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 0

        expect(response[1][0]).to eq 'KB'
        expect(response[1][1]).to eq 0

        expect(response[2][0]).to eq 'MB'
        expect(response[2][1]).to eq 1
      end

      it 'MB + 1' do
        response = UnitSplit.split((MB + 1).to_s,
          UnitSplit::Unit::Byte)
        expect(response.length).to eq 3

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 1

        expect(response[1][0]).to eq 'KB'
        expect(response[1][1]).to eq 0

        expect(response[2][0]).to eq 'MB'
        expect(response[2][1]).to eq 1
      end

      it 'MB + KB + 1' do
        response = UnitSplit.split((MB + KB + 1).to_s,
          UnitSplit::Unit::Byte)
        expect(response.length).to eq 3

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 1

        expect(response[1][0]).to eq 'KB'
        expect(response[1][1]).to eq 1

        expect(response[2][0]).to eq 'MB'
        expect(response[2][1]).to eq 1
      end

    end

    describe 'border case (sec)' do

      it '0, 1, 59 sec' do
        response = UnitSplit.split('0',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 1
        expect(response[0][1]).to eq 0

        response = UnitSplit.split('1',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 1
        expect(response[0][1]).to eq 1

        response = UnitSplit.split('59',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 1
        expect(response[0][1]).to eq 59
      end

      it 'just 1 min' do
        response = UnitSplit.split('60',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 2

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 0

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 1
      end

      it '1 min 59 sec' do
        response = UnitSplit.split('119',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 2

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 59

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 1
      end

      it '2 min' do
        response = UnitSplit.split('120',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 2

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 0

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 2
      end

      it '59 min 59 sec' do
        response = UnitSplit.split('3599',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 2

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 59

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 59
      end

      it '1 hour' do
        response = UnitSplit.split('3600',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 3

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 0

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 0

        expect(response[2][0]).to eq "hour"
        expect(response[2][1]).to eq 1
      end

      it '1 hour 1 sec' do
        response = UnitSplit.split('3601',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 3

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 1

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 0

        expect(response[2][0]).to eq "hour"
        expect(response[2][1]).to eq 1
      end

      it '1 hour 1 min 1 sec' do
        response = UnitSplit.split('3661',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 3

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 1

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 1

        expect(response[2][0]).to eq "hour"
        expect(response[2][1]).to eq 1
      end

      it '23 hour 59 min 59 sec' do
        response = UnitSplit.split('86399',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 3

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 59

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 59

        expect(response[2][0]).to eq "hour"
        expect(response[2][1]).to eq 23
      end

      it '1 day' do
        response = UnitSplit.split('86400',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 4

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 0

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 0

        expect(response[2][0]).to eq "hour"
        expect(response[2][1]).to eq 0

        expect(response[3][0]).to eq "day"
        expect(response[3][1]).to eq 1
      end

      it '1 year' do
        response = UnitSplit.split('31536000',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 5

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 0

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 0

        expect(response[2][0]).to eq "hour"
        expect(response[2][1]).to eq 0

        expect(response[3][0]).to eq "day"
        expect(response[3][1]).to eq 0

        expect(response[4][0]).to eq "year"
        expect(response[4][1]).to eq 1
      end

      it '500 year' do
        response = UnitSplit.split('15768000000',
          UnitSplit::Unit::Second)
        expect(response.length).to eq 5

        expect(response[0][0]).to be_nil
        expect(response[0][1]).to eq 0

        expect(response[1][0]).to eq "min"
        expect(response[1][1]).to eq 0

        expect(response[2][0]).to eq "hour"
        expect(response[2][1]).to eq 0

        expect(response[3][0]).to eq "day"
        expect(response[3][1]).to eq 0

        expect(response[4][0]).to eq "year"
        expect(response[4][1]).to eq 500
      end

    end

  end

end
