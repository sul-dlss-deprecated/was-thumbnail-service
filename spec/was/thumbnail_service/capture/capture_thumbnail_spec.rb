include Was::ThumbnailService::Capture

RSpec.configure do |c|
  c.filter_run_excluding :image_prerequisite
end

describe Was::ThumbnailService::Capture::CaptureThumbnail do

  VCR.configure do |config|
    config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
    config.hook_into :webmock
  end

  before :all do
    @fixtures = 'spec/fixtures/'
    @memento_html = File.read("#{@fixtures}/memento.txt")
  end

  describe '.initialize' do
    it 'initializes the object with the parameters' do
      capture_thumbnail = CaptureThumbnail.new(1, 'ab123cd4567', 'memento-uri','19990104000000')
      expect(capture_thumbnail.instance_variable_get(:@id)).to eq(1)
      expect(capture_thumbnail.instance_variable_get(:@druid_id)).to eq('ab123cd4567')
      expect(capture_thumbnail.instance_variable_get(:@memento_uri)).to eq('memento-uri')
      expect(capture_thumbnail.instance_variable_get(:@memento_datetime)).to eq('19990104000000')
      expect(capture_thumbnail.instance_variable_get(:@temporary_file)).to eq("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000")
    end
  end

  describe '.process_thumbnail' do
    it 'calls the steps to create a thumbnail with jp2_required' do
      Rails.configuration.jp2_required = true
      capture_thumbnail = CaptureThumbnail.new(1, '', 'memento-uri', '19990104000000')
      allow(capture_thumbnail).to receive(:capture).and_return('')
      allow(capture_thumbnail).to receive(:resize_temporary_image).with("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")
      allow_any_instance_of(Assembly::Image).to receive(:create_jp2).with(:output=>"#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jp2")
      allow(FileUtils).to receive(:rm)
      allow(capture_thumbnail).to receive(:save_to_stack)
      allow(capture_thumbnail).to receive(:update_database)

      expect(capture_thumbnail).to receive(:capture)
      expect(capture_thumbnail).to receive(:resize_temporary_image).with("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")
      expect_any_instance_of(Assembly::Image).to receive(:create_jp2).with(:output=>"#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jp2")
      expect(capture_thumbnail).to receive(:save_to_stack)
      expect(capture_thumbnail).to receive(:update_database)

      capture_thumbnail.process_thumbnail
    end
    it 'calls the steps to create a thumbnail with jp2_required equals false' do
      Rails.configuration.jp2_required = false
      capture_thumbnail = CaptureThumbnail.new(1, '', 'memento-uri', '19990104000000')
      allow_any_instance_of(CaptureThumbnail).to receive(:capture).and_return('')
      allow_any_instance_of(CaptureThumbnail).to receive(:resize_temporary_image).with("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")
      allow_any_instance_of(CaptureThumbnail).to receive(:save_to_stack)
      allow_any_instance_of(CaptureThumbnail).to receive(:update_database)

      expect_any_instance_of(CaptureThumbnail).to receive(:capture)
      expect_any_instance_of(CaptureThumbnail).to receive(:resize_temporary_image).with("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")
      expect_any_instance_of(CaptureThumbnail).to receive(:save_to_stack)
      expect_any_instance_of(CaptureThumbnail).to receive(:update_database)

      capture_thumbnail.process_thumbnail
    end
    it 'raises an error if there is a problem in capturing the thumbnail' do
      capture_thumbnail = CaptureThumbnail.new(1, '', 'memento-uri', '19990104000000')
      allow_any_instance_of(CaptureThumbnail).to receive(:capture).and_return('#FAIL#')
      expect{capture_thumbnail.process_thumbnail}.to raise_error("Thumbnail for memento memento-uri can't be generated.\n#FAIL#")
    end
  end

  describe '.capture' do
    before :each do
      if File.exist?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")
        FileUtils.rm("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")
      end
    end
    it 'creates an jp2 temporary image for a webpage', :image_prerequisite do
      Rails.configuration.jp2_required = true
      VCR.use_cassette('slac_19990104000000') do
        capture_thumbnail = CaptureThumbnail.new(1, '', 'https://swap.stanford.edu/19990104000000/http://www.slac.stanford.edu/','19990104000000')
        result = capture_thumbnail.capture
        expect(result.length).to eq(0)
        expect(File.exist?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jp2")).to be true
        expect(File.exist?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")).to be false
      end
    end
    it 'creates an jpeg temporary image for a webpage' do
      Rails.configuration.jp2_required = false
      VCR.use_cassette('slac_19990104000000') do
        capture_thumbnail = CaptureThumbnail.new(1, '', 'https://swap.stanford.edu/19990104000000/http://www.slac.stanford.edu/','19990104000000')
        result = capture_thumbnail.capture
        expect(result.length).to eq(0)
        expect(File.exist?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jp2")).to be false
        expect(File.exist?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")).to be true
      end
    end
    it 'returns result message if there is an error' do
      VCR.use_cassette('notexistent_20120101120000') do
        capture_thumbnail = CaptureThumbnail.new(1, '', 'https://swap.stanford.edu/20120101120000/http://not.existent.edu/','20120101120000')
        result = capture_thumbnail.capture
        expect(result.length).to be > 0
        expect(File.exist?("#{Rails.configuration.thumbnail_tmp_directory}/20120101120000.jpeg")).to be false
        expect(File.exist?("#{Rails.configuration.thumbnail_tmp_directory}/20120101120000.jp2")).to be false
      end
    end

    after :each do
      if File.exist?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")
        FileUtils.rm("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jpeg")
      end
      if File.exist?("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jp2")
        FileUtils.rm("#{Rails.configuration.thumbnail_tmp_directory}/19990104000000.jp2")
      end
    end
  end

  describe '.save_to_stack' do
    before :all do
      tmp_directory = "#{@fixtures}/tmp_directory"
      image_stacks = "#{@fixtures}/image_stacks"
      FileUtils.cp("#{@fixtures}/19961125000000.jpeg","#{tmp_directory}/19961125000000.jpeg")
      FileUtils.cp("#{@fixtures}/19961125000000.jp2","#{tmp_directory}/19961125000000.jp2")
      Rails.configuration.thumbnail_tmp_directory = tmp_directory
      Rails.configuration.image_stacks = image_stacks
    end
    it 'copies the jpeg thumbnail file from the temp location to the stacks location' do
      Rails.configuration.jp2_required = false
      capture_thumbnail = CaptureThumbnail.new(1, 'aa111aa1111', '', '19961125000000')
      capture_thumbnail.save_to_stack

      expect(File.exist?("#{@fixtures}/image_stacks/aa/111/aa/1111/19961125000000.jpeg")).to be true
    end
    it 'raises an error if the source file is not available' do
      Rails.configuration.jp2_required = false
      capture_thumbnail = CaptureThumbnail.new(1, 'aa111aa1111', '', '19991125000000')
      expect{capture_thumbnail.save_to_stack}.to raise_error(Errno::ENOENT)
    end
    it 'copies the jp2 thumbnail file from the temp location to the stacks location' do
      Rails.configuration.jp2_required = true
      capture_thumbnail = CaptureThumbnail.new(1, 'aa111aa1111', '', '19961125000000')
      capture_thumbnail.save_to_stack

      expect(File.exist?("#{@fixtures}/image_stacks/aa/111/aa/1111/19961125000000.jp2")).to be true
    end
    it 'raises an error if the source file is not available' do
      Rails.configuration.jp2_required = true
      capture_thumbnail = CaptureThumbnail.new(1, 'aa111aa1111', '', '19991125000000')
      expect{capture_thumbnail.save_to_stack}.to raise_error(Errno::ENOENT)
    end
    after :all do
      if File.exist?("#{@fixtures}/image_stacks/aa/")
        FileUtils.rm_r("#{@fixtures}/image_stacks/aa/")
      end
    end
  end

  describe '.update_database' do
    before :all do
      @memento11 = Memento.create({:id=>10001, :uri_id=>1001, :memento_uri=>'https://swap.stanford.edu/19980901000000/http://test1.edu/', :memento_datetime=>'1998-09-01 00:00:00', :is_selected=>'true', :is_thumbnail_captured=>'false'})
    end
    it 'updates is_thumbnail_captured for the memento record in the database' do
      capture_thumbnail = CaptureThumbnail.new(10001, '', 'https://swap.stanford.edu/19980901000000/http://test1.edu/', '19980901000000')
      capture_thumbnail.update_database

      expect(Memento.find(10001)[:is_thumbnail_captured]).to be true
    end
    it 'raises an error if the memento id is not found' do
      capture_thumbnail = CaptureThumbnail.new(10002, '', '', '')
      expect{capture_thumbnail.update_database}.to raise_error(ActiveRecord::RecordNotFound)
    end
    after :all do
      @memento11.destroy
    end
  end

  describe '.resize_temporary_image' do
    it 'resizes the image with extra width to maximum 400 pixel width', :image_prerequisite do
      temporary_image = 'tmp/thum_extra_width.jpeg'
      FileUtils.cp 'spec/fixtures/thumbnail_files/image_extra_width.jpeg',temporary_image
      CaptureThumbnail.new(1, '', '', '').resize_temporary_image temporary_image
      expect(FileUtils.compare_file(temporary_image, 'spec/fixtures/thumbnail_files/thum_extra_width.jpeg')).to be_truthy
    end
    it 'resizes the image with extra height to maximum 400 pixel height', :image_prerequisite do
      temporary_image = 'tmp/thum_extra_height.jpeg'
      FileUtils.cp 'spec/fixtures/thumbnail_files/image_extra_height.jpeg', temporary_image
      CaptureThumbnail.new(1, '', '', '').resize_temporary_image temporary_image
      expect(FileUtils.compare_file(temporary_image, 'spec/fixtures/thumbnail_files/thum_extra_height.jpeg')).to be_truthy
    end

    after :each do
      FileUtils.rm_rf 'tmp/thum_extra_width.jpeg' if File.exist?('tmp/thum_extra_width.jpeg')
      FileUtils.rm 'tmp/thum_extra_height.jpeg' if File.exist?('tmp/thum_extra_height.jpeg')
    end
  end
end
