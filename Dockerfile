FROM --platform=$BUILDPLATFORM node:20 AS frontend
ARG TARGETOS
ARG TARGETARCH

WORKDIR /surmai
RUN mkdir node_modules
ADD src src
ADD public public
COPY .eslintrc.cjs .
COPY index.html .
COPY package.json .
COPY postcss.config.js .
COPY tsconfig.app.json .
COPY tsconfig.json .
COPY tsconfig.node.json .
COPY vite.config.ts .

RUN npm install -g npm@10.3.0 # For windows
RUN npm install --no-audit
RUN npm run build

FROM --platform=$BUILDPLATFORM golang:1.23.4-alpine3.21 AS backend
ARG TARGETOS
ARG TARGETARCH

WORKDIR /build

# Copy the go.mod and go.sum files to the /build directory
COPY backend/go.mod .
COPY backend/go.sum .
RUN go mod download

COPY backend .
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o surmai-backend


FROM alpine:3.21

COPY backend/init.sh /pb/init.sh
COPY backend/datasets /datasets
COPY --from=frontend /surmai/dist /pb_public
COPY --from=backend /build/surmai-backend /pb/surmai-backend

EXPOSE 8080

# start PocketBase
CMD ["/pb/init.sh"]
