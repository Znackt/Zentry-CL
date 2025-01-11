FROM node:22.13.0-alpine AS builder

WORKDIR /build

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install

COPY . .

RUN npm run build

FROM node:22.13.0-alpine AS runner

WORKDIR /app

COPY --from=builder /build/node_modules node_modules
COPY --from=builder /build/package.json package.json
COPY --from=builder /build/package-lock.json package-lock.json
COPY --from=builder /build/dist/ dist/
COPY --from=builder /build/vite.config.js vite.config.js

EXPOSE 5173

CMD [ "npm", "run", "preview" ]