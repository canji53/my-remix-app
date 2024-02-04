FROM public.ecr.aws/docker/library/node:20.9.0-alpine AS base

FROM base AS builder
RUN apk add --no-cache openssl
WORKDIR /app
COPY . .
RUN npm ci
RUN npm run build

FROM base AS runner
# lambda-adapterを追加（important!!）
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.1 /lambda-adapter /opt/extensions/lambda-adapter
WORKDIR /app
ENV NODE_ENV=production PORT=3000
COPY ./package.json ./package-lock.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/build ./build
COPY --from=builder /app/public ./public
CMD ["./node_modules/.bin/remix-serve", "./build/index.js"]