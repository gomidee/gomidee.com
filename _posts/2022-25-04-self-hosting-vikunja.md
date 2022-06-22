---
title: "How to Self-Host Vikunja"
layout: post
description: self-hosting to-do application
summary: 
tags: self-hosting tutorial
minute: 3
image: 
---

Vikunja is a To-Do app licensed under AGPL-3.0, it's a great little project. I decided to self-host my own instance and here's how I did it.

I don't overly enjoy using Docker but I made an exception for Vikunja as it's extremely easy to set it up. Please note that I'm running <strong>Ubuntu 20.04 LTS</strong>, you can use a different distro instead. Now it's time for you to get your hands dirty!

I use Tailscale in order to connect my devices, it also helps to further harden my setup (you could use WireGuard instead, it should work just fine). Here's how I like to do it.

<h2>Here's what you need</h2>
- A virtual private server (VPS): you can get the cheapest option, it will work just fine. I use <a href="https://1984.hosting">1984 Hosting</a> as my hosting provider, but you can use another one if you want to.
- A domain name (optional)
- Tailscale (optional)

<h3>Gettin' down to business</h3>
1. Hardening your server

Please refer to my hardening <a href="https://github.com/gomidee/Hardening">guide</a>, you'll need to follow some steps manually, after that you can run the script:

<pre><code>wget https://raw.githubusercontent.com/gomidee/Hardening/main/palmtree.sh
chmod +x palmtree.sh
sudo ./palmtree.sh</code></pre>

<strong>Please enable port 22 (or your chosen ssh port) when prompted to select firewall ports, otherwise you'll be locked out of ssh!</strong>

2. Hardening docker

Docker doesn't respect iptable rules by default, add the following line to <strong>/etc/docker/daemon.json</strong> and <strong>/etc/default/docker</strong>, respectively.

<pre><code>{ "iptables": false }</pre></code>

<pre><code>DOCKER_OPTS="--iptables=false"</pre></code>

3. Setup Tailscale (optional)

When running the Palmtree script you were promted to install Tailscale, if you didn't and would like to use it on your setup you can run the following command:

<pre><code>curl -fsSL https://tailscale.com/install.sh | sh</code></pre>

Cool! Now you're good to create the <strong>docker-compose.yml</strong> file.

4. Setting up Vikunja and Nginx

First, install nginx, we'll need it soon.

<pre><code>sudo apt-get update
sudo apt-get install nginx</code></pre>

Let's create a directory to keep things organised

<pre><code>mkdir vikunja</code></pre>

Now download the docker-compose and the nginx template by running:

<pre><code>wget https://gist.githubusercontent.com/dnburgess/5c93209089ee80c13e2834664a4267dc/raw/5ed387bdb92bd153311ed5596c428a44ac2fe7e6/gistfile1.txt
wget https://gist.githubusercontent.com/dnburgess/5e09f5de59d5f0aa5ac908dfc2dadaca/raw/67aa9bb60f4254fb2e4e2b53c785b1bf70ce356f/gistfile1.txt
</code></pre>

Go ahead and edit the docker-compose file and make any changes that you wish:

- Ports 
- Front end url
- Email
- Password

After you finished editing the file, we can deploy the container! YEEEWWW

First enable the port that you chose

<pre><code>docker-compose up -d</code></pre>

We use the -d argument so that docker runs in detached mode... so it runs on the background.

Disable UFW, type your server's and the port... Like this: 93.95.100.12:8022
You could also type the machine's Tailscale address: 100.69.20.149.50:8022

You should see Vikunja!

4. Hardening with Tailscale and setting up our domain name

Enable ufw again... this is the part were we harden our server. I'll explain how this will work and what the strategy is. I'll use images to illustrate this:

<img src=images/tailscale.jpg>

You can see in the image above a bunch of IPs, these are the internal IPs, much like your home LAN. This means they are only accessible on the Tailscale network.. <strong>cool right?</strong>

Tailscale is a different interface so if you type <strong>ip addr</strong> on your Linux server you should be able to see an interfaced named <strong>tailscale0</strong>. Like this:

<img src=images/example.jpg>

Our goal is to make port 8022 unreachable from the outside but reachable from inside our network. We can do this by running:

<pre><code>ufw allow in on tailscale0 to any port 8022 proto tcp</code></pre>

If you type <strong>ufw status</strong> you should see something like this:

<img src=images/ports.jpg>

Awesome! Now we need this <strong>thing</strong> to be accessible in through our domain. Now... setup a subdomain so you can access vikunja. I chose vik, so I can access it at <strong>vik.gomidee.com</strong>

Tip: If you're new to all of this, go to <a href="https://landchad.net">landchad.net</a>. It will make much more sense.

After setting up the subdomain record you'll need to use nginx to proxy whatever is happening in our internal network accessible on the outside network.

Let's open our doors to the outside world!

<pre><code>ufw allow 80
ufw allow 443</code></pre>

<h4>Let's show them what we got!</h4>
I use VIM as my text editor you can use nano or whatever. Do the following...

<pre><code>vim /etc/nginx/sites-enabled/vik</code></pre>

Copy and paste the following:

<pre><code>server {

         server_name vik.yourawesomedomain.com;

	location / {

	      proxy_pass http://TAILSCALEIP:8022;

	      }
}</code></pre>

Change the domain and the Tailscale IP (if you used a different port change 8022 to whatever port you're using)

<strong>Last thing! CERTBOT</strong>, let's encrypt this connection!

<pre><code>apt install python3-certbot-nginx
certbot --nginx
</code></pre>

BANG! Go visit your Vikunja instance!


<h3>If you have any questions please you can reach out to me on my <a href="https://gomidee.com/contact">contact</a> page.</h3>







