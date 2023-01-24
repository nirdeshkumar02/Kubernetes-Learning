helm install -f values/redis-values.yaml rediscart charts/redis

helm install -f values/email-service-values.yaml emailservice charts/microservices
helm install -f values/cart-service-values.yaml cartservice charts/microservices
helm install -f values/currency-service-values.yaml currencyservice charts/microservices
helm install -f values/payment-service-values.yaml paymentservice charts/microservices
helm install -f values/recommendation-service-values.yaml recommendationservice charts/microservices
helm install -f values/productcatalog-service-values.yaml productcatalogservice charts/microservices
helm install -f values/shipping-service-values.yaml shippingservice charts/microservices
helm install -f values/ad-service-values.yaml adservice charts/microservices
helm install -f values/checkout-service-values.yaml checkoutservice charts/microservices
helm install -f values/frontend-values.yaml frontendservice charts/microservices
