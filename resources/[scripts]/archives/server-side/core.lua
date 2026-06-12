local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
