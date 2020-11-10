
CONF=~/.config/heron
MNESIA_BASE=Mnesia.nonode@nohost
MNESIA_LOCAL=$(CONF)/database


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

$(CONF):
	mkdir ~/.config/heron 

database: $(CONF) $(MNESIA_LOCAL)

clean-db:
	rm -rf $(MNESIA_BASE) $(MNESIA_LOCAL)

$(MNESIA_BASE):
	mix amnesia.create -d Heron.Database --disk

$(MNESIA_LOCAL): $(MNESIA_BASE)
	mv $(MNESIA_BASE) $(MNESIA_LOCAL) 

