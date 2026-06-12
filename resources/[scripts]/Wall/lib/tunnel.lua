Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")

Resource = GetCurrentResourceName()
config = config or {}

if IsDuplicityVersion() then
    vRP = Proxy.getInterface("vRP")
    vRPclient = Tunnel.getInterface("vRP")

    RegisterTunnel = {}
    Tunnel.bindInterface(Resource,RegisterTunnel)

    vTunnel = Tunnel.getInterface(Resource)
else
    vRP = Proxy.getInterface("vRP")
    vRPserver = Tunnel.getInterface(Resource)

    RegisterTunnel = {}
    Tunnel.bindInterface(Resource,RegisterTunnel)

    vTunnel = Tunnel.getInterface(Resource)
end
