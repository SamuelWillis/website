FROM ghcr.io/livebook-dev/livebook:0.18.3

# Apps configuration
ENV LIVEBOOK_APPS_PATH "/apps"
ENV LIVEBOOK_APPS_PATH_WARMUP "manual"
ENV LIVEBOOK_APPS_PATH_HUB_ID "personal-hub"

# Notebook
COPY metrics.livemd /apps/

# Cache apps setup at build time
RUN /app/bin/warmup_apps

# --- Clustering ---

# Runtime configuration to cluster multiple Livebook nodes on Fly.io
RUN printf '\
    export ERL_AFLAGS="-proto_dist inet6_tcp"\n\
    export LIVEBOOK_NODE="${FLY_APP_NAME}-${FLY_IMAGE_REF##*-}@${FLY_PRIVATE_IP}"\n\
    export LIVEBOOK_CLUSTER="dns:${FLY_APP_NAME}.internal"\n\
    ' > /app/user/env.sh
