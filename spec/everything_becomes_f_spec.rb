require 'spec_helper'
require 'pry'

describe "EverythingBecomesF" do
  it 'has a version number' do
    expect(EverythingBecomesF::VERSION).not_to be nil
  end

  describe "#everything_became_f?" do
    describe Integer do
      where(:integer, :result) do
        [
          [0, false],
          [1, false],
          [10, false],
          [15, true],
          [16, false],
          [254, false],
          [255, true],
          [256, false],
          [65534, false],
          [65535, true],
          [65536, false]
        ]
      end

      with_them do
        subject { integer.everything_became_f? }

        it { is_expected.to eq result }
      end
    end

    describe String do
      where(:string, :result) do
        [
          ['a', false],
          ['af', false],
          ['fa', false],
          ['A', false],
          ['AF', false],
          ['FA', false],
          ['ffffffffffffffffffffffffffffffffffffffffffffffffffe', false],
          ['effffffffffffffffffffffffffffffffffffffffffffffffff', false],
          ['f', true],
          ['fF', true],
          ['FF', true],
          ['ffffffffffffffffffffffffffffffffffffffffffffffffff', true],
          ['FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', true]
        ]
      end

      with_them do
        subject { string.everything_became_f? }

        it { is_expected.to eq result }
      end
    end

    describe Time do
      ENV['TZ'] = 'UTC'

      where(:time, :result) do
        [
          [Time.new(1970, 1, 1, 0, 0, 15), true],
          [Time.new(1970, 1, 1, 0, 4, 15), true],
          [Time.new(1970, 1, 1, 1, 8, 15), true],
          [Time.new(1970, 1, 1, 18, 12, 15), true],
          [Time.new(1970, 1, 13, 3, 16, 15), true],
          [Time.new(1970, 7, 14, 4, 20, 15), true],
          [Time.new(1978, 7, 4, 21, 24, 15), true],
          [Time.new(2106, 2, 7, 6, 28, 15), true],
          [Time.new(4147, 8, 20, 7, 32, 15), true],
          [Time.new(36812, 2, 20, 0, 36, 15), true],
          [Time.new(559444, 3, 8, 9, 40, 15), true],
          [Time.new(1970, 1, 1, 0, 0, 0), false],
          [Time.new(2015, 12, 24, 0, 0, 0), false]
        ]
      end

      with_them do
        subject { time.everything_became_f? }

        it { is_expected.to eq result }
      end
    end
  end

  describe "#everything_becomes_f" do
    describe Integer do
      where(:integer, :result) do
        [
          [0, 15],
          [1, 15],
          [10, 15],
          [15, 15],
          [16, 255],
          [254, 255],
          [255, 255],
          [256, 4095],
          [65534, 65535],
          [65535, 65535]
        ]
      end

      with_them do
        subject { integer.everything_becomes_f }

        it { is_expected.to eq result }
        it { expect(subject.everything_became_f?).to eq true }
      end
    end

    describe String do
      where(:string, :result) do
        [
          ['a', 'f'],
          ['af', 'ff'],
          ['fa', 'ff'],
          ['ffffffffffffffffffffffffffffffffffffffffffffffffffe', 'fffffffffffffffffffffffffffffffffffffffffffffffffff'],
          ['あいうえお', 'fffff']
        ]
      end

      with_them do
        subject { string.everything_becomes_f }

        it { is_expected.to eq result }
        it { expect(subject.everything_became_f?).to eq true }
      end
    end

    describe Time do
      ENV['TZ'] = 'UTC'

      where(:time, :result) do
        [
          [Time.new(1970, 1, 1, 0, 0, 14), Time.new(1970, 1, 1, 0, 0, 15)],
          [Time.new(1970, 1, 1, 0, 0, 15), Time.new(1970, 1, 1, 0, 0, 15)],
          [Time.new(1970, 1, 1, 0, 0, 16), Time.new(1970, 1, 1, 0, 4, 15)],
          [Time.new(1978, 7, 4, 21, 24, 14), Time.new(1978, 7, 4, 21, 24, 15)],
          [Time.new(1978, 7, 4, 21, 24, 15), Time.new(1978, 7, 4, 21, 24, 15)],
          [Time.new(1978, 7, 4, 21, 24, 16), Time.new(2106, 2, 7, 6, 28, 15)]
        ]
      end

      with_them do
        subject { time.everything_becomes_f }

        it { is_expected.to eq result }
        it { expect(subject.everything_became_f?).to eq true }
      end
    end
  end
end
