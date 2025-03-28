require 'spec_helper'

describe Av::Commands::Base do
  let(:subject) { Av.cli }
  let(:source) { File.new(Dir.pwd + '/spec/support/assets/sample.mp4').path }

  describe '.identify' do
    describe 'supported files' do
      let(:meta) { subject.identify source }

      it { expect(meta).to be_a Hash }
      it { expect(meta.keys).to include :size, :aspect, :width, :height, :length, :duration }
    end

# I'm not sure how to get a valid, yet unsupported file in here now. ffmpeg now assumes an fps
# of 25 for images so this will have valid metadata now.
#
#    describe 'unsupported files' do
#      let(:unsupported) { File.new(Dir.pwd + '/spec/support/assets/image.png').path }
#      let(:meta) { subject.identify unsupported }
#
#      it { expect(meta).to be_nil }
#    end
  end

  describe '.add_input_param' do
    before do
      subject.add_input_param({k: 'value'})
    end
    it { expect(subject.input_params.to_s).to eq '-k value' }
    context 'multiple calls' do
      before do
        subject.add_input_param({k: 'value1'})
        subject.add_input_param(:k, 'value2')
        subject.add_input_param([:x, 'y'])
      end
      it { expect(subject.input_params.to_s).to eq '-k value,value1,value2 -x y' }
    end
  end

  describe '.add_output_param' do
    before do
      subject.add_output_param({k: 'value'})
    end
    it { expect(subject.output_params.to_s).to eq '-k value' }
    context 'multiple calls' do
      before do
        subject.add_output_param({k: 'value1'})
        subject.add_output_param(:k, 'value2')
        subject.add_output_param([:x, 'y'])
      end
      it { expect(subject.output_params.to_s).to eq '-k value,value1,value2 -x y' }
    end
  end

  describe '.filter_seek' do
    before do
      subject.filter_seek('00:00:01.11')
    end

    it { expect(subject.input_params.to_s).to eq "-ss 00:00:01.11" }
  end

  describe '.run' do
    before do
      subject.add_output_param(ar: 44100)
      subject.add_source(source)
      subject.add_destination(Tempfile.new(['one', '.ogv']).path)
    end
    it { expect { subject.run }.not_to raise_exception }

  end

  describe '.metadata_rotate' do
    before do
      subject.metadata_rotate(90)
    end

    it { expect(subject.output_params.to_s).to eq '-metadata:s:v:0 rotate=90' }
  end

  describe '.filter_metadata_rotate' do
    before do
      subject.add_source(source)
      subject.filter_metadata_rotate(90)
    end

    it { expect(subject.output_params.to_s).to match /-metadata:s:v:0 rotate=270/ }
    it { expect(subject.output_params.to_s).to match /-vf '(clock|transpose=1)'/ }
  end
end

