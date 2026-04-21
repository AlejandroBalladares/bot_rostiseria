require 'spec_helper'

ENV['CLIMA_API_URL'] = 'https://api.openweathermap.org'
ENV['CLIMA_API_KEY'] = 'ab9e0422c113553533a7879f2a1df13e'

describe ClimaApiImpl do
  it 'obtener clima actual' do
    esta_lloviendo = ClimaApiImpl.new.esta_lloviendo?
    expect(esta_lloviendo).to_not be_nil
  end
end

describe ClimaApiMock do
  it 'dia lluvioso' do
    esta_lloviendo = ClimaApiMock.new(true).esta_lloviendo?
    expect(esta_lloviendo).to be true
  end

  it 'dia soleado' do
    esta_lloviendo = ClimaApiMock.new(false).esta_lloviendo?
    expect(esta_lloviendo).to be false
  end
end
