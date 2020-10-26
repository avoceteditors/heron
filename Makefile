

escript:
	mix escript.build

release:
	mix release

install: escript release
	mix escript.install

docs:
	mix docs
	rsync -avz doc/* /var/www/html/heron

status:
	systemctl status heron.service

cat:
	cat _build/dev/systemd/lib/systemd/system/heron.service
