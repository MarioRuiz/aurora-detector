require 'net/http'
require 'json'

def connect_camera
  result=true
  begin
    @http = Net::HTTP.new('192.168.1.1', 80)
    res = @http.post('/osc/commands/execute', {name: "camera.startSession"}.to_json)
    @sessionId = JSON.parse(res.body)["results"]["sessionId"]

    #set api to version 2 and options
    resp=@http.post('/osc/commands/execute',
                    {
                        name: "camera.setOptions",
                        parameters: {
                            sessionId: @sessionId,
                            options: {
                                clientVersion: 2
                            }
                        }
                    }.to_json)

    resp=@http.post('/osc/commands/execute',
                    {
                        name: "camera.setOptions",
                        parameters: {
                            sessionId: @sessionId,
                            options: {
                                exposureProgram: 1,
                                iso: ISO,
                                shutterSpeed: SHUTTER_SPEED
                            }
                        }
                    }.to_json)

  rescue Exception => e
    @logger.fatal "Problem on connect_camera"
    @logger.fatal e
  end


end


def take_picture
  success=false

  connect_camera unless defined?(@http)

  begin

    params = {
        name: "camera.setOptions",
        parameters: {
            sessionId: @sessionId,
            options: {captureMode: "image"}
        }
    }.to_json
    resp=@http.post('/osc/commands/execute', params)


    params = {name: "camera.takePicture"}.to_json
    resp=@http.post('/osc/commands/execute', params)

    init=Time.now
    file_url=""
    while file_url=="" do
      if (Time.now-init)>(SHUTTER_SPEED*5)
        @logger.fatal "It seems like there is a problem taking the picture"
        return false
      end
      sleep 5
      resp=@http.post('/osc/state', "")
      file_url = JSON.parse(resp.body)["state"]["_latestFileUrl"]
    end

    res = @http.get(file_url.to_s.gsub("http://192.168.1.1", ""))

    open("./files/image.jpg", "wb") {|f| f.write(res.body)}

    begin
      @http.post('/osc/commands/execute', {name: "camera.delete", parameters: {fileUrls: file_url}}.to_json)
    rescue Exception => exc
      @logger.fatal "Error deleting the file #{file_url} from the camera"
      @logger.fatal exc
    end
    success=true
  rescue Exception => exc
    @logger.fatal "Problem at take_picture"
    @logger.fatal exc
    begin
      params = {name: "camera.closeSession", parameters: {sessionId: @sessionId}}.to_json
      @http.post('/osc/commands/execute', params)
      @http.finish
      @http = nil
    rescue Exception => e
      @logger.fatal "Problem closing camera connection"
      @logger.fatal e
      @http.finish
      @http = nil
    end

  end
  return success
end