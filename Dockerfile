FROM public.ecr.aws/lambda/python:3.12

COPY ./src/requirements.txt ./

RUN pip install -r ./requirements.txt

COPY ./src/lambda_function.py ./

CMD [ "lambda_function.lambda_handler" ]