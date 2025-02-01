FROM nginx:latest
COPY src/main/webapp/jsps/home.jsp /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
