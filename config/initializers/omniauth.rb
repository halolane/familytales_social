Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development?
  	provider :twitter, "T8UzczR1zEKHaCuXBEbGA", "UGiwBVRZAvVUUIdCQ0Fmhds1EikD93yfoLfugKnhU"
  else
  	provider :twitter, "DYw8eF53dvYFyCGNt2J5A", "64z6BGJ83g9GygnIRCmJh1lESYpLcaG6HvKeuIM"
  end
end