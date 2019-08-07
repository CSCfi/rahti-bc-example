FROM nginx:mainline-alpine

# Based on Torsten Walter's nginx openshift modifications at 
# https://github.com/torstenwalter/openshift-nginx

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwX /var/cache/nginx /var/run /var/log/nginx
RUN chgrp -R root /var/cache/nginx

# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8080;/' /etc/nginx/conf.d/default.conf
EXPOSE 8080

# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

COPY index.html /usr/share/nginx/html/index.html
