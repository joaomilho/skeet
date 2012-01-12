require 'magick/crop_resized'

class MaileeShots < Sinatra::Base
  configure do
    IMGKit.configure do |config|
      config.wkhtmltoimage = File.join(File.dirname(__FILE__), 'bin', 'wkhtmltoimage-amd64')
      config.default_options = { quality: 75 }
    end
  end

  # "mailee-shots.heroku.com/softa/template/9658" 
  URL = "http://%s.mailee.me/clients/%s/%s_%s.html" 
  get '/:client/:klass/:id' do
    # Request must come from Mailee's ip.
    # halt unless request.ip == '74.86.147.210'
    # expires 1600, :public, :proxy_revalidate
    client, klass, id = [params[:client], params[:klass], params[:id]]
    url = URL % [client, client, klass, id]

    headers({
      'Content-Disposition' => 'inline',
      'Content-Type' => 'image/jpeg'
    })

    image = IMGKit.new(url).to_img
    resize = Magick::Image.from_blob(image).first.crop_resized!(300, 300)
    image = resize.to_blob
    image
  end

end