require 'faraday'

class ClimaApi
  def esta_lloviendo?
    raise NotImplementedError
  end
end

class ClimaApiImpl < ClimaApi
  LAT_BUENOS_AIRES = -34.6075682
  LON_BUENOS_AIRES = -58.4370894

  CLIMA_API_URL = 'https://api.openweathermap.org'
  CLIMA_API_KEY = 'ab9e0422c113553533a7879f2a1df13e'

  def esta_lloviendo?
    clima = obtener_clima
    clima['weather'].first['main'] == 'Rain'
  end

  private

  def obtener_clima
    logger.debug("Obteniendo clima de #{CLIMA_API_URL}")

    begin
      response = Faraday.get("#{CLIMA_API_URL}/data/2.5/weather", { lat: LAT_BUENOS_AIRES, lon: LON_BUENOS_AIRES, appid: CLIMA_API_KEY })
      JSON.parse(response.body)
    rescue StandardError => e
      logger.error("Error al obtener clima: #{e}")
    end
  end
end

class ClimaApiMock < ClimaApi
  def new(esta_lloviendo)
    initialize(esta_lloviendo)
  end

  def esta_lloviendo?
    @esta_lloviendo
  end

  private
  def initialize(esta_lloviendo)
    @esta_lloviendo = esta_lloviendo
  end
end
