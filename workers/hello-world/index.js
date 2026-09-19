export default {
  async fetch(request, env) {
    return new Response(JSON.stringify({
      service: "arise-v9",
      status: "operational",
      environment: env.ENVIRONMENT || "production",
      version: env.VERSION || "1.0.0",
      timestamp: new Date().toISOString()
    }), {
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
      }
    });
  }
};
