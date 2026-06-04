String getWeatherDescription(double temperature) {
  if (temperature < 0) {
    return "It's freezing outside! Bundle up warmly.";
  } else if (temperature < 10) {
    return "It's quite cold. Don't forget your jacket.";
  } else if (temperature < 20) {
    return "It's cool outside. A light sweater should be enough.";
  } else if (temperature < 30) {
    return 'The weather is warm and pleasant.';
  } else if (temperature < 40) {
    return "It's hot outside! Stay hydrated.";
  } else {
    return "It's extremely hot! Avoid going out if possible.";
  }
}
