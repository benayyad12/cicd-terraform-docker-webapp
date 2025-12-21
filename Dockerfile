FROM nginx:alpine
COPY app/index.html /usr/share/nginx/html/index.html
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost/ || exit 1
ENTRYPOINT ["nginx"] 
CMD ["-g", "daemon off;"] 