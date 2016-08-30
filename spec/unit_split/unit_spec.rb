require 'spec_helper'

describe UnitSplit::Unit do

  it 'has unit constants' do
    expect(UnitSplit::Unit::JapaneseNumber).not_to be nil
    expect(UnitSplit::Unit::Byte).not_to be nil
    expect(UnitSplit::Unit::Second).not_to be nil
  end

end
