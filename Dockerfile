# Stage 1: Build Hugo site
FROM hugomods/hugo:latest AS builder

WORKDIR /build

# Copy theme submodule
COPY themes/ /build/themes/

# Copy site files
COPY hugo.toml /build/
COPY content/ /build/content/
COPY layouts/ /build/layouts/
COPY assets/ /build/assets/
COPY static/ /build/static/

# Build with minification
RUN hugo --minify --baseURL "https://santi.ramisclar.cat"

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built site
COPY --from=builder /build/public /usr/share/nginx/html

# Custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]