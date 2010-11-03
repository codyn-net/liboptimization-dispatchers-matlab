import java.io.*;
import java.net.*;

import ch.epfl.biorob.optimization.messages.task.*;

class TaskInterface
{
	public static Java.Task Read(InputStream inps) throws IOException
	{
		int ss = ReadSize(inps);
		byte buffer[] = new byte[ss];
		inps.read(buffer, 0, ss);

		Java.Communication comm = Java.Communication.parseFrom(buffer);

		if (comm.getType() == Java.Communication.Type.CommunicationTask)
		{
			return comm.getTask();
		}
		else
		{
			return null;
		}
	}

	public static double Parameter(Java.Task task, String name)
	{
		for (int i = 0; i < task.getParametersCount(); ++i)
		{
			Java.Task.Parameter parameter = task.getParameters(i);

			if (parameter.getName().equals(name))
			{
				return parameter.getValue();
			}
		}

		return 0;
	}

	public static Java.Task.KeyValue[] Settings(Java.Task task)
	{
		Java.Task.KeyValue[] settings = new Java.Task.KeyValue[task.getSettingsCount()];

		for (int i = 0; i < task.getSettingsCount(); ++i)
		{
			settings[i] = task.getSettings(i);
		}

		return settings;
	}

	public static Java.Task.Parameter[] Parameters(Java.Task task)
	{
		Java.Task.Parameter[] parameters = new Java.Task.Parameter[task.getParametersCount()];

		for (int i = 0; i < task.getParametersCount(); ++i)
		{
			parameters[i] = task.getParameters(i);
		}

		return parameters;
	}

	public static String Setting(Java.Task task, String name)
	{
		for (int i = 0; i < task.getSettingsCount(); ++i)
		{
			Java.Task.KeyValue setting = task.getSettings(i);

			if (setting.getKey().equals(name))
			{
				return setting.getValue();
			}
		}

		return null;
	}

	public static String Data(Java.Task task, String name)
	{
		for (int i = 0; i < task.getDataCount(); ++i)
		{
			Java.Task.KeyValue data = task.getData(i);

			if (data.getKey().equals(name))
			{
				return data.getValue();
			}
		}

		return null;
	}

	private static int ReadSize(InputStream inps) throws IOException
	{
		StringBuffer buffer = new StringBuffer();

		while (true)
		{
			char b = (char)inps.read();
		
			if (b == ' ')
			{
				break;
			}

			buffer.append(b);
		}

		return Integer.parseInt(buffer.toString());
	}

	public static void Write(OutputStream outs, Java.Communication.Builder builder) throws IOException
	{
		Java.Communication comm = builder.build();
		com.google.protobuf.ByteString.Output out = com.google.protobuf.ByteString.newOutput();

		comm.writeTo(out);

		byte message[] = out.toByteString().toByteArray();

		String ss = (new Integer(message.length)).toString() + " ";
		outs.write(ss.getBytes());
		outs.write(message);

		outs.flush();
	}

	public static Java.Response.Builder CreateResponse()
	{
		Java.Response.Builder ret = Java.Response.newBuilder();

		ret.setId(0);
		ret.setStatus(Java.Response.Status.Success);

		return ret;
	}

	public static void SetFailure(Java.Response.Builder response, Java.Response.Failure.Type type, String message)
	{
		response.setStatus(Java.Response.Status.Failed);

		Java.Response.Failure.Builder ret = Java.Response.Failure.newBuilder();

		ret.setType(type);
		ret.setMessage(message);

		response.setFailure(ret.build());
	}

	public static Java.Communication.Builder CreateCommunication()
	{
		Java.Communication.Builder ret = Java.Communication.newBuilder();

		ret.setType(Java.Communication.Type.CommunicationResponse);

		return ret;
	}

	public static Java.Response.Fitness.Builder CreateFitness()
	{
		return Java.Response.Fitness.newBuilder();
	}

	public static void AddFitness(Java.Response.Builder response, Java.Response.Fitness.Builder fitness)
	{
		response.addFitness(fitness.build());
	}

	public static void AddFitness(Java.Response.Builder response, String name, double value)
	{
		Java.Response.Fitness.Builder fit = CreateFitness();
		fit.setName(name);
		fit.setValue(value);

		AddFitness(response, fit);
	}

	public static Java.Response.KeyValue.Builder CreateData()
	{
		return Java.Response.KeyValue.newBuilder();
	}

	public static void AddData(Java.Response.Builder response, Java.Response.KeyValue.Builder data)
	{
		response.addData(data.build());
	}

	public static void AddData(Java.Response.Builder response, String name, String value)
	{
		Java.Response.KeyValue.Builder dat = CreateData();

		dat.setKey(name);
		dat.setValue(value);

		AddData(response, dat);
	}
}
