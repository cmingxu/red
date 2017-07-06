FROM partlab/ubuntu-ruby

RUN gem install bundler

ADD . /app
WORKDIR /app

#RUN chown -R nobody:nogroup /app
#USER nobody
RUN bundle install

ENV RAILS_ENV development

EXPOSE 3001

#RUN ["bundle", "exec", "rake", "db:create"]
#RUN ["bundle", "exec", "rake", "db:migrate"]
#RUN ["bundle", "exec", "rake", "db:seed"]

CMD ["bundle", "exec", "rails", "s", "-p", "3001", "-b", "0.0.0.0" ]
