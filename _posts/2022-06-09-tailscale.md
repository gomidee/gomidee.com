---
title: "Tailscale: How and Why I use it"
layout: post
description: tailscale is the best
summary: 
tags: Guide
minute: 5
---

Tailscale is a secure network based on WireGuard. It requires no open ports to connect devices and unlike traditional VPNs, clients are connect to each other, reducing latency. Here's a visual representation:

<img src="/images/tailscaling.jpg">
<h3> Why use Tailscale </h3>
Currently I have a VPS on <a href="https://1984.hosting">1984Hosting</a> and a Raspberry Pi running at home.

My VPS runs this website and some other instances while my Pi runs and AdGuardHome DNS server an RSS feed reader, I also use it as a NAS. 

When I'm on the go, I sometimes need access to the files on my Pi. While on public transport, I like to have a look at my RSS feeds and sometimes check network traffic. Traditionally, to access this information I would need multiple open ports on my home network, which isn't safe at all and my IP address would change over time, which is a burden if it happens when I'm outside.

...This is where Tailscale comes in...

<h4>  Tailscale in a nutshell. </h4>

Think about your home network (LAN). Typically you would have a bunch of devices connected, if you wanted to ssh into one your computers you can simply run ssh i-am-cool[@]192.168.1.10 (for example), this connection is local so it doesn't require access to the "internet" (WAN). 

You can think of Tailscale as a LAN made better... You can access it from anywhere and all connections between devices are end-to-end encrypted. 

<h3>What can you do with it???</h3>

Well, you can do a bunch of cool stuff...

- Don't expose ssh connections through the internet
- Reverse proxy Docker instances
- Make instances hosted at your house accessible over the internet securely
- Easily and securely setup a NAS
- Have friends connect to your Minecraft server "locally"

<h3> How I use Tailscale </h3>
I have Tailscale installed on every device I have, which means that I can easily access any of them wherever and whenever. I've made a beautiful visual representation of my network:

<img src="/images/cool.png">

My VPS is the front-end to the internet. If I ever wanted to access my AdGuardHome instance that I run at home I can easily make a reverse proxy and access it through my domain.

<h4>Avoid open ports:</h4>

Currently, I only have port 443 open on my VPS as all the other ports I need are accessed from the "internal network". When I setup my Vikunja instance I didn't want port 8022 to be reachable from the outside so I only allowed it through the Tailscale interface, you can do this with pretty much anything...

<h4>Encrypted DNS:</h4>
As mentioned I run and AdGuardHome instance. I can use the IP of my Pi to be the DNS server of my Tailscale network which allows me to:

- Have a network-wide ad-blocker everywhere
- Have all my DNS queries encrypted

<h4>VPN</h4>
This is one of the biggest strengths of Tailscale, in my opinion. Because it works behind NAT, it doesn't require any open ports. That means I can use my Pi as a little VPN server so I always have my home IP address wherever I am. I could also use my VPS as an exit node and watch Netflix in Iceland; or invite friends on my network and use their IPs as exit nodes.

I hope you enjoyed the post. Cheers...
