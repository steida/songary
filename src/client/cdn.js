export function silhouetteUrl() {
  return '/assets/img/silhouette.png';
}

// Url rewritter for dev/production/cdn etc. Also handles old paths.
// TODO: If src belongs to app (is absolute), then rewrite for CDN.
export function url(src): string {
  // Rewrite old paths.
  if (src === '/app/client/img/silhouette.png')
    return silhouetteUrl();
  return src;
}
